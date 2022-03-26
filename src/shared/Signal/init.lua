local Types = require(script.Types)

type Connection = Types.Connection
type Signal = Types.Signal

local freeRunnerThread: thread? = nil
local runEventHandlerInFreeThread = nil

do
	local function acquireRunnerThreadAndCallEventHandler(fn: (...any) -> ...any, ...)
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
Connection.prototype = {}
Connection.prototype.connected = true
Connection.__index = Connection.prototype

function Connection.new(signal: Signal, fn: (...any) -> ...any): Connection
	return setmetatable({
		_signal = signal,
		_fn = fn,
	}, Connection)
end

function Connection.prototype:disconnect()
	if self.connected then
		self.connected = false

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
Signal.prototype = {}
Signal.__index = Signal.prototype

function Signal.prototype:connect(fn: (...any) -> ...any)
	local connection = Connection.new(self, fn)

	if self._last then
		connection._next = self._last
	end

	self._last = connection

	return connection
end

function Signal.prototype:fire(...)
	local connection = self._last

	while connection do
		if connection.connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
			end

			task.spawn(freeRunnerThread, connection._fn, ...)
		end

		connection = connection._next
	end
end

function Signal.prototype:wait(): ...any
	local waitingCoroutine = coroutine.running()

	local connection = nil
	connection = self:connect(function(...)
		connection:disconnect()

		task.spawn(waitingCoroutine, ...)
	end)

	return coroutine.yield()
end

function Signal.prototype:destroy()
	local last = self._last

	while last do
		last.connected = false
		last = last._next
	end

	self._last = nil
end

function Signal.is(object)
	return type(object) == "table" and getmetatable(object) == Signal
end

function Signal.new(): Signal
	return setmetatable({}, Signal)
end

return Signal :: {
	is: (object: any) -> boolean,
	new: () -> Signal,
}
