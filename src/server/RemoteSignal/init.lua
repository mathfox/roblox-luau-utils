local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local RemoteSignal = {}
RemoteSignal.prototype = {}
RemoteSignal.__index = RemoteSignal.prototype

function RemoteSignal.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == RemoteSignal
end

local function new()
	if not RunService:IsServer() then
		error("RemoteSignal can only be created on the server", 2)
	end

	return setmetatable({
		_remote = Instance.new("RemoteEvent"),
	}, RemoteSignal)
end

export type RemoteSignal = typeof(new())

function RemoteSignal.new(): RemoteSignal
	return new()
end

function RemoteSignal.prototype:Fire(player: Player, ...)
	self._remote:FireClient(player, ...)
end

function RemoteSignal.prototype:FireAll(...)
	self._remote:FireAllClients(...)
end

function RemoteSignal.prototype:FireExcept(exceptPlayer: Player, ...)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= exceptPlayer then
			self._remote:FireClient(player, ...)
		end
	end
end

function RemoteSignal.prototype:Wait()
	return self._remote.OnServerEvent:Wait()
end

function RemoteSignal.prototype:Connect(handler: (...any) -> ...any)
	return self._remote.OnServerEvent:Connect(function(player: Player, ...)
		handler(player, ...)
	end)
end

function RemoteSignal.prototype:Destroy()
	self._remote:Destroy()
	self._remote = nil
end

RemoteSignal.prototype.fire = RemoteSignal.prototype.Fire
RemoteSignal.prototype.fireAll = RemoteSignal.prototype.FireAll
RemoteSignal.prototype.fireExcept = RemoteSignal.prototype.FireExcept
RemoteSignal.prototype.wait = RemoteSignal.prototype.Wait
RemoteSignal.prototype.connect = RemoteSignal.prototype.Connect
RemoteSignal.prototype.destroy = RemoteSignal.prototype.Destroy

return RemoteSignal
