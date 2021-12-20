local IS_SERVER = game:GetService("RunService"):IsServer()

local Connection = {}
Connection.__index = Connection

function Connection.new(event, connection)
	local self = setmetatable({
		_conn = connection,
		_event = event,
		Connected = true,
	}, Connection)
	return self
end

function Connection:IsConnected()
	if self._conn then
		return self._conn.Connected
	end
	return false
end

function Connection:Disconnect()
	if self._conn then
		self._conn:Disconnect()
		self._conn = nil
	end
	if not self._event then
		return
	end
	self.Connected = false
	local connections = self._event._connections
	for i, c in ipairs(connections) do
		if c == self then
			connections[i] = connections[#connections]
			connections[#connections] = nil
			break
		end
	end
	self._event = nil
end

Connection.Destroy = Connection.Disconnect

local ClientRemoteSignal = {}
ClientRemoteSignal.__index = ClientRemoteSignal

function ClientRemoteSignal.is(object)
	return type(object) == "table" and getmetatable(object) == ClientRemoteSignal
end

function ClientRemoteSignal.new(remoteEvent)
	assert(not IS_SERVER, "ClientRemoteSignal can only be created on the client")
	assert(
		typeof(remoteEvent) == "Instance",
		"Argument #1 (RemoteEvent) expected Instance; got " .. typeof(remoteEvent)
	)
	assert(
		remoteEvent:IsA("RemoteEvent"),
		"Argument #1 (RemoteEvent) expected RemoteEvent; got" .. remoteEvent.ClassName
	)
	local self = setmetatable({
		_remote = remoteEvent,
		_connections = {},
	}, ClientRemoteSignal)
	return self
end

function ClientRemoteSignal:Fire(...)
	self._remote:FireServer(...)
end

function ClientRemoteSignal:Wait()
	return self._remote.OnClientEvent:Wait()
end

function ClientRemoteSignal:Connect(handler)
	local connection = Connection.new(
		self,
		self._remote.OnClientEvent:Connect(function(...)
			handler(...)
		end)
	)
	table.insert(self._connections, connection)
	return connection
end

function ClientRemoteSignal:Destroy()
	for _, c in ipairs(self._connections) do
		if c._conn then
			c._conn:Disconnect()
		end
	end
	self._connections = nil
	self._remote = nil
end

return ClientRemoteSignal
