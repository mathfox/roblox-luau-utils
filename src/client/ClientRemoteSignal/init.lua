local ClientRemoteSignal = {}
ClientRemoteSignal.__index = ClientRemoteSignal

function ClientRemoteSignal.is(object)
	return type(object) == "table" and getmetatable(object) == ClientRemoteSignal
end

function ClientRemoteSignal.new(remoteEvent: RemoteEvent)
	return setmetatable({
		_remote = remoteEvent,
	}, ClientRemoteSignal)
end

function ClientRemoteSignal:Fire(...)
	self._remote:FireServer(...)
end

function ClientRemoteSignal:Wait()
	return self._remote.OnClientEvent:Wait()
end

function ClientRemoteSignal:Connect(handler)
	return self._remote.OnClientEvent:Connect(handler)
end

ClientRemoteSignal.fire = ClientRemoteSignal.Fire
ClientRemoteSignal.wait = ClientRemoteSignal.Wait
ClientRemoteSignal.connect = ClientRemoteSignal.Connect

return ClientRemoteSignal
