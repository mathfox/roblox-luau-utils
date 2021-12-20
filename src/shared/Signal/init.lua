type Function = (...any) -> ...any

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
Connection.prototype = {}
Connection.prototype.Connected = true
Connection.__index = Connection.prototype

function Connection.new(signal: Signal, fn: Function): Connection
	local constructor: {
		Connected: boolean,
		_signal: Signal,
		_fn: Function,
		_previous: Connection?,
	} = {
		_signal = signal,
		_fn = fn,
	}

	local self = setmetatable(constructor, Connection)

	return self
end

function Connection.prototype:Disconnect()
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

Connection.prototype.disconnect = Connection.prototype.Disconnect

local Signal = {}
Signal.prototype = {}
Signal.__index = Signal.prototype

function Signal.prototype:Connect(fn: Function): Connection
	local connection = Connection.new(self, fn)

	if self._previous then
		connection._previous = self._previous

		self._previous = connection
	else
		self._previous = connection
	end

	return connection
end

function Signal.prototype:Fire(...: any)
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

function Signal.prototype:Wait(): ...any
	local waitingCoroutine = coroutine.running()

	local connection
	connection = self:Connect(function(...: any)
		connection:Disconnect()

		task.spawn(waitingCoroutine, ...)
	end)

	return coroutine.yield()
end

function Signal.prototype:Destroy()
	self._previous = nil
end

Signal.prototype.connect = Signal.prototype.Connect
Signal.prototype.fire = Signal.prototype.Fire
Signal.prototype.wait = Signal.prototype.Wait
Signal.prototype.destroy = Signal.prototype.Destroy

function Signal.new(): Signal
	local constructor: {
		_previous: Connection?,
	} = {}

	local self = setmetatable(constructor, Signal)

	return self
end

export type Signal = typeof(Signal.new())
export type Connection = typeof(Connection.new(Signal.new(), function() end))

function Signal.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Signal
end

return Signal
