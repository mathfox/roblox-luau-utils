local Unite = require(game:GetService("ReplicatedStorage").Unite)

local Promise = Unite.getSharedUtil("Promise")
local Signal = Unite.getSharedUtil("Signal")
local Maid = Unite.getSharedUtil("Maid")

local PlayerStorageCachePrototype = {}
PlayerStorageCachePrototype.__index = PlayerStorageCachePrototype

function PlayerStorageCachePrototype:getCachedPlayerStorage(player: Player, ...): table
	local cache = self._cache

	local storage = cache[player]
	if storage then
		if not storage._isLoaded then
			storage._loadSignal:Wait()
		end

		return storage._storage
	end

	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		error("#1 argument must be a Player!", 2)
	end

	if self._onVerify then
		local success, message = self._onVerify(player, ...)

		if not success then
			return player:Kick(message)
		end
	end

	local loadStartTime = os.clock()

	local maid = Maid.new()

	maid:givePromise(Promise.fromEvent(player.AncestryChanged, function()
		return not player:IsDescendantOf(game)
	end):andThen(function()
		cache[player] = nil
		maid:Destroy()
	end))

	local newCache = {
		_isLoaded = false,
		_loadSignal = Signal.new(),
	}

	cache[player] = newCache

	local setupStorage = self._onSetup(player, ...)
	newCache._storage = setupStorage

	-- ability to implement custom .Destroy which will be called on player leave
	if type(setupStorage) == "table" then
		if type(setupStorage.destroy) == "function" or type(setupStorage.Destroy) == "function" then
			maid:giveTask(setupStorage)
		end
	end

	newCache._isLoaded = true
	newCache._loadSignal:Fire(os.clock() - loadStartTime)

	return setupStorage
end

return PlayerStorageCachePrototype
