local Players = game:GetService("Players")

local RemoteSignal = {}
RemoteSignal.__index = RemoteSignal

function RemoteSignal.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == RemoteSignal
end

function RemoteSignal.new()
	return setmetatable({
		_remote = Instance.new("RemoteEvent"),
	}, RemoteSignal)
end

function RemoteSignal:Fire(player: Player, ...)
	self._remote:FireClient(player, ...)
end

function RemoteSignal:FireAll(...)
	self._remote:FireAllClients(...)
end

function RemoteSignal:FireExcept(exceptPlayer: Player, ...)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= exceptPlayer then
			self._remote:FireClient(player, ...)
		end
	end
end

function RemoteSignal:Wait()
	return self._remote.OnServerEvent:Wait()
end

function RemoteSignal:Connect(handler: (...any) -> ...any)
	return self._remote.OnServerEvent:Connect(function(player: Player, ...)
		handler(player, ...)
	end)
end

function RemoteSignal:Destroy()
	self._remote:Destroy()
	self._remote = nil
end

RemoteSignal.fire = RemoteSignal.Fire
RemoteSignal.fireAll = RemoteSignal.FireAll
RemoteSignal.fireExcept = RemoteSignal.FireExcept
RemoteSignal.wait = RemoteSignal.Wait
RemoteSignal.connect = RemoteSignal.Connect
RemoteSignal.destroy = RemoteSignal.Destroy

return RemoteSignal
