type Function = (...any) -> ...any
type ConnectionConstructor = {
	Connected: boolean?,
	_signal: Signal,
	_fn: Function,
	_previous: Connection?,
}

type SignalConstructor = {
	_previous: Connection?,
}

local freeRunnerThread: thread? = nil

local function acquireRunnerThreadAndCallEventHandler(fn: Function, ...: any)
	local acquiredRunnerThread = freeRunnerThread
	freeRunnerThread = nil
	fn(...)
	freeRunnerThread = acquiredRunnerThread
end

local function runEventHandlerInFreeThread(...)
	acquireRunnerThreadAndCallEventHandler(...)

	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

local Connection = {}
Connection.Connected = true
Connection.__index = Connection

function Connection.new(signal: Signal, fn: Function): Connection
	local constructor: ConnectionConstructor = {
		_signal = signal,
		_fn = fn,
	}

	local self = setmetatable(constructor, Connection)

	return self
end

function Connection:Disconnect()
	if not self.Connected then
		return
	else
		self.Connected = false

		if self._signal._previous == self then
			self._signal._previous = self._previous
		else
			local current = self._signal._previous

			while current and current._previous ~= self do
				current = current._previous
			end

			if current then
				current._previous = self._previous
			end
		end
	end
end

Connection.disconnect = Connection.Disconnect

local Signal = {}
Signal.__index = Signal
Signal.__metatable = "The metatable is locked"

function Signal:Connect(fn: Function): Connection
	local connection = Connection.new(self, fn)

	if self._previous then
		connection._previous = self._previous

		self._previous = connection
	else
		self._previous = connection
	end

	return connection
end

function Signal:Fire(...: any)
	local connection = self._previous

	while connection do
		if connection.Connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
			end

			task.spawn(freeRunnerThread :: thread, connection._fn, ...)
		end

		connection = connection._previous
	end
end

function Signal:Wait(): ...any
	local waitingCoroutine = coroutine.running()

	local connection
	connection = self:Connect(function(...: any)
		connection:Disconnect()

		task.spawn(waitingCoroutine, ...)
	end)

	return coroutine.yield()
end

function Signal:Destroy()
	self._previous = nil
end

Signal.connect = Signal.Connect
Signal.fire = Signal.Fire
Signal.wait = Signal.Wait
Signal.destroy = Signal.Destroy

function Signal.new(): Signal
	local constructor: SignalConstructor = {}
	local self = setmetatable(constructor, Signal)
	return self
end

export type Signal = typeof(Signal.new())
export type Connection = typeof(Connection.new(Signal.new(), function() end))

function Signal.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Signal
end

return Signal
