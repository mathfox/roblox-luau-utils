local ClientRemoteSignal = {}
ClientRemoteSignal.prototype = {}
ClientRemoteSignal.__index = ClientRemoteSignal.prototype

function ClientRemoteSignal.is(object)
	return type(object) == "table" and getmetatable(object) == ClientRemoteSignal
end

function ClientRemoteSignal.new(remoteEvent: RemoteEvent)
	local self = setmetatable({
		_remote = remoteEvent,
	}, ClientRemoteSignal)

	return self
end

function ClientRemoteSignal.prototype:Fire(...)
	self._remote:FireServer(...)
end

function ClientRemoteSignal.prototype:Wait()
	return self._remote.OnClientEvent:Wait()
end

function ClientRemoteSignal.prototype:Connect(handler)
	return self._remote.OnClientEvent:Connect(handler)
end

ClientRemoteSignal.prototype.fire = ClientRemoteSignal.prototype.Fire
ClientRemoteSignal.prototype.wait = ClientRemoteSignal.prototype.Wait
ClientRemoteSignal.prototype.connect = ClientRemoteSignal.prototype.Connect

return ClientRemoteSignal
