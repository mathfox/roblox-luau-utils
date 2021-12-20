local DataStoreService = game:GetService("DataStoreService")

local GlobalDataStore3Prototype = {
	_globalStore = DataStoreService:GetGlobalDataStore(),
}

function GlobalDataStore3Prototype:getValue(globalKey)
	local currentValue, keyInfo = self._globalStore:GetAsync(globalKey)
	return currentValue
end

function GlobalDataStore3Prototype:setValue(globalKey, newValue, userIds, storeSetOptions)
	local newVersion = self._globalStore:SetAsync(globalKey, newValue, userIds, storeSetOptions)
end

function GlobalDataStore3Prototype:incrementValue(globalKey, incrementValue, userIds, storeSetOptions)
	local newValue = self._globalStore:IncrementAsync(globalKey, incrementValue, userIds, storeSetOptions)
	return newValue
end

function GlobalDataStore3Prototype:updateValue(globalKey, transformFunction)
	local updatedValue, keyInfo = self._globalStore:UpdateAsync(globalKey, transformFunction)
end

function GlobalDataStore3Prototype:removeValue(globalKey, transformFunction)
	local removedValue, keyInfo = self._globalStore:RemoveAsync(globalKey, transformFunction)
end

return GlobalDataStore3Prototype
