local Unite = require(game:GetService("ReplicatedStorage").Unite)
local DataStoreService = game:GetService("DataStoreService")

local Promise = Unite.getSharedUtil("Promise")

local DataStore3Prototype = {}
DataStore3Prototype.__index = DataStore3Prototype

function DataStore3Prototype.new(dataStoreName: string, scopeName: string?, dataStoreOptions: DataStoreOptions?): {}
	if type(dataStoreName) ~= "string" then
		error("#1 argument must be a string!", 2)
	end

	return setmetatable({
		_dataStoreName = dataStoreName,
		_dataStore = DataStoreService:GetDataStore(dataStoreName, scopeName, dataStoreOptions),
		_orderedDataStore = DataStoreService:GetOrderedDataStore(dataStoreName, scopeName),
	}, DataStore3Prototype)
end

function DataStore3Prototype:promiseGetValue(defaultValue: any)
	return Promise.resolve(self._orderedDataStore:GetSortedAsync(false, 1):GetCurrentPage()[1])
		:andThen(function(mostRecentKey)
			if not mostRecentKey then
				return defaultValue
			end

			local recentKey = mostRecentKey.value
			self._mostRecentKey = recentKey
			return Promise.resolve(self._dataStore:GetAsync(recentKey))
				:catch(function()
					warn("error while executing getAsync")
				end)
				:expect()
		end)
		:catch(function()
			warn("error while executing getSortedAsync")
		end)
end

function DataStore3Prototype:GetValue(...)
	return self:promiseGetValue(...):expect()
end

function DataStore3Prototype:promiseSetValue(newValue: any, userIds: { number }?, storeSetOptions: DataStoreSetOptions?)
	local recentKey = (self._mostRecentKey or 0) + 1
	return Promise.resolve(self._dataStore:SetAsync(recentKey, newValue, userIds, storeSetOptions))
		:andThen(function()
			return Promise.resolve(self._orderedDataStore:SetAsync(recentKey, recentKey))
				:tap(function()
					self._mostRecentKey = recentKey
				end)
				:catch(function()
					warn("error while executing ordered setAsync")
				end)
				:expect()
		end)
		:catch(function()
			warn("error while executing setAsync")
		end)
end

function DataStore3Prototype:setValue(...)
	return self:promiseSetValue(...):expect()
end

function DataStore3Prototype:promiseUpdateValue(updateFunction)
	local recentKey = self._mostRecentKey or 0
	return Promise.resolve(self._dataStore:UpdateAsync(recentKey, updateFunction)):catch(function()
		warn("error while updateAsync")
	end)
end

function DataStore3Prototype:updateValue(...)
	return self:promiseUpdateValue(...):expect()
end

return DataStore3Prototype
