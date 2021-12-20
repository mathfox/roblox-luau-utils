local Unite = require(game:GetService("ReplicatedStorage").Unite)
local Players = game:GetService("Players")

local Promise = Unite.getSharedUtil("Promise")
local Maid = Unite.getSharedUtil("Maid")

local PlayerDebounce = {
	ClassName = "PlayerDebounce",
}
PlayerDebounce.__index = PlayerDebounce

function PlayerDebounce.is(object)
	return type(object) == "table" and object.ClassName == PlayerDebounce.ClassName
end

function PlayerDebounce.once(successFunction, failFunction)
	if type(successFunction) ~= "function" then
		error("#1 argument must be a function!", 2)
	elseif type(failFunction) ~= "function" and failFunction ~= nil then
		error("#2 argument must be a function or nil!", 2)
	end

	local self = setmetatable({
		_ticksCache = {},
		_maid = Maid.new(),
	}, PlayerDebounce)

	local function connectUnbonceOnPlayerLeave(player)
		self._maid:GivePromise(Promise.fromEvent(player.AncestryChanged, function()
			return not player:IsDescendantOf(game)
		end):andThen(function()
			self:unbounceForPlayer(player)
		end))
	end

	if type(failFunction) == "function" then
		self.OnInvoke = function(player, ...)
			if self:_getLastPlayerInvokeTick(player) then
				return failFunction(player, ...)
			else
				self:_setLastPlayerInvokeTick(player)
				connectUnbonceOnPlayerLeave(player)
				return successFunction(player, ...)
			end
		end
	else
		self.OnInvoke = function(player, ...)
			if not self:_getLastPlayerInvokeTick(player) then
				self:_setLastPlayerInvokeTick(player, tick())
				connectUnbonceOnPlayerLeave(player)
				return successFunction(player, ...)
			end
		end
	end

	return self
end

function PlayerDebounce.time(debounceTime, successFunction, failFunction)
	if type(debounceTime) ~= "number" then
		error("#1 argument must be a number!", 2)
	elseif math.abs(successFunction) == math.huge or debounceTime <= 0 then
		error("Debounce time must be over zero and not infinity!", 2)
	elseif type(successFunction) ~= "function" then
		error("#2 argument must be a function!", 2)
	elseif type(failFunction) ~= "function" and failFunction ~= nil then
		error("#3 argument must be a function or nil!", 2)
	end

	local self = setmetatable({
		_ticksCache = {},
		_maid = Maid.new(),
	}, PlayerDebounce)

	if type(failFunction) == "function" then
		self.OnInvoke = function(player, ...)
			local cachedTick = self:_getLastPlayerInvokeTick(player)
			local currentTick = tick()

			if not cachedTick or currentTick - cachedTick >= debounceTime then
				self:_updateLastPlayerInvokeTick(player, currentTick)
				return successFunction(player, ...)
			else
				return failFunction(player, ...)
			end
		end
	else
		self.OnInvoke = function(player, ...)
			local cachedTick = self:_getLastPlayerInvokeTick(player)
			local currentTick = tick()

			if not cachedTick or currentTick - cachedTick >= debounceTime then
				self:_updateLastPlayerInvokeTick(player, currentTick)
				return successFunction(player, ...)
			end
		end
	end

	self._maid:giveTask(Players.PlayerRemoving:Connect(function(player)
		local ticksCache = self._ticksCache
		if ticksCache[player] then
			ticksCache[player] = nil
		end
	end))

	return self
end

function PlayerDebounce:_getLastPlayerInvokeTick(player)
	return self._ticksCache[player]
end

function PlayerDebounce:_updateLastPlayerInvokeTick(player, tickNumber)
	self._ticksCache[player] = tickNumber
end

function PlayerDebounce:unbounceForPlayer(player)
	self._ticksCache[player] = nil
end

function PlayerDebounce:Destroy()
	self._maid:Destroy()
end

return PlayerDebounce
