local Unite = require(game:GetService("ReplicatedStorage").Unite)
local Players = game:GetService("Players")

local Promise = require(Unite.SharedUtils.Promise)
local Maid = require(Unite.SharedUtils.Maid)

local Debounce = {}
Debounce.Player = {}
Debounce.Player.__index = Debounce.Player

function Debounce.Player.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Debounce.Player
end

function Debounce.Player.once(successFunction, failFunction)
	if type(successFunction) ~= "function" then
		error("#1 argument must be a function!", 2)
	elseif type(failFunction) ~= "function" and failFunction ~= nil then
		error("#2 argument must be a function or nil!", 2)
	end

	local self = setmetatable({
		_ticksCache = {},
		_maid = Maid.new(),
	}, Debounce.Player)

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

function Debounce.Player.time(debounceTime, successFunction, failFunction)
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
	}, Debounce.Player)

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

function Debounce.Player:_getLastPlayerInvokeTick(player)
	return self._ticksCache[player]
end

function Debounce.Player:_updateLastPlayerInvokeTick(player, tickNumber)
	self._ticksCache[player] = tickNumber
end

function Debounce.Player:unbounceForPlayer(player: Player)
	self._ticksCache[player] = nil
end

function Debounce.Player:Destroy()
	self._maid:Destroy()
end

Debounce.Player.destroy = Debounce.Player.Destroy

local DebounceMetatable = {}
DebounceMetatable.__index = require(Unite.SharedUtils.Debounce)

setmetatable(Debounce, DebounceMetatable)

return Debounce
