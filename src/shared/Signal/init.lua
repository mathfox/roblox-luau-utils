local Types = require(script.Parent.Types)

export type Signal<T...> = Types.Signal<T...>
export type Connection = Types.Connection
type Proc<T...> = Types.Proc<T...>

local freeRunnerThread: thread? = nil
local runEventHandlerInFreeThread = nil

do
	local function acquireRunnerThreadAndCallEventHandler(fn: Proc<...any>, ...)
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

local Connection = {} :: Connection & {
	_signal: Signal<...any> & { _last: (Connection & { _next: Connection? })? },
	_fn: Proc<...any>,
}
Connection.connected = true
Connection.__index = Connection

function Connection:__tostring()
	return "Connection"
end

function Connection:disconnect(...)
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

table.freeze(Connection)

type LastConnection = Connection & { _next: LastConnection? }

local Signal = {}
Signal.prototype = {} :: Signal<...any> & {
	_last: LastConnection?,
}
Signal.__index = Signal.prototype

function Signal:__tostring()
	return "Signal"
end

function Signal.is(object)
	return type(object) == "table" and getmetatable(object) == Signal
end

function Signal.new()
	return setmetatable({}, Signal) :: Signal<...any>
end

function Signal.prototype:connect(fn: Proc<...any>, ...)
	local connection = setmetatable({ _signal = self, _fn = fn }, Connection) :: Connection

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

			task.spawn(freeRunnerThread :: thread, connection._fn, ...)
		end

		connection = connection._next
	end
end

function Signal.prototype:wait(...)
	local waitingCoroutine = coroutine.running()

	local connection: Connection = nil
	connection = self:connect(function(...)
		connection:disconnect()

		task.spawn(waitingCoroutine, ...)
	end)

	return coroutine.yield()
end

function Signal.prototype:destroy(...)
	local last = self._last

	while last do
		last.connected = false
		last = last._next
	end

	self._last = nil
end

table.freeze(Signal)
table.freeze(Signal.prototype)

return Signal
