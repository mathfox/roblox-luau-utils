type Function = (...any) -> (...any)?

local freeRunnerThread: thread? = nil
local runEventHandlerInFreeThread = nil

do
	local function acquireRunnerThreadAndCallEventHandler(fn: Function, ...)
		local acquiredRunnerThread = freeRunnerThread
		freeRunnerThread = nil
		fn(...)
		freeRunnerThread = acquiredRunnerThread
	end

	function runEventHandlerInFreeThread(...)
		acquireRunnerThreadAndCallEventHandler(...)

		while true do
			acquireRunnerThreadAndCallEventHandler(coroutine.yield())
		end
	end
end

local Connection = {}
Connection.Connected = true
Connection.__index = Connection

function Connection.new(signal: Signal, fn: Function): Connection
	local self = setmetatable({
		_signal = signal,
		_fn = fn,
	}, Connection)

	return self
end

function Connection:disconnect()
	if self.Connected then
		self.Connected = false

		if self._signal._last == self then
			self._signal._last = self._next
		else
			local previous = self._signal._last

			while previous and previous._next ~= self do
				previous = previous._next
			end

			if previous then
				previous._next = self._next
			end
		end
	end
end

local Signal = {}
Signal.__index = Signal

function Signal:connect(fn: Function): Connection
	local connection = Connection.new(self, fn)

	if self._last then
		connection._next = self._last
	end

	self._last = connection

	return connection
end

function Signal:fire(...: any)
	local connection = self._last

	while connection do
		if connection.Connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
			end

			task.spawn(freeRunnerThread, connection._fn, ...)
		end

		connection = connection._next
	end
end

function Signal:wait(): ...any
	local waitingCoroutine = coroutine.running()

	local connection = nil
	connection = self:connect(function(...: any)
		connection:disconnect()

		task.spawn(waitingCoroutine, ...)
	end)

	return coroutine.yield()
end

function Signal:destroy()
	local last = self._last

	while last do
		last.Connected = false
		last = last._next
	end

	self._last = nil
end

function Signal.new(): Signal
	local self = setmetatable({}, Signal)
	return self
end

export type Signal = typeof(Signal.new())
export type Connection = typeof(Connection.new(Signal.new(), function() end))

function Signal.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Signal
end

return Signal
