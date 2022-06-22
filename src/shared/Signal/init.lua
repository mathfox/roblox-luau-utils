--!strict

local Types = require(script.Parent.Types)

export type Signal<T... = ...any> = Types.Signal<T...>
export type Connection = Types.Connection
type Proc<T... = ...any> = Types.Proc<T...>

type SignalConstructor = {
	is: (object: any) -> boolean,
	new: <T...>() -> Signal<T...>,
	prototype: Signal,
}
type AnyConnection = Connection

local freeRunnerThread: thread? = nil

local function acquireRunnerThreadAndCallEventHandler(fn: Proc, ...)
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

local Connection = {} :: { [any]: any, _next: any }
Connection.__index = Connection

function Connection.__tostring(): "Connection"
	return "Connection"
end

function Connection:disconnect()
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

local Signal = {} :: { [any]: any, _last: any }
Signal.prototype = {}
Signal.__index = Signal.prototype

function Signal.__tostring(): "Signal"
	return "Signal"
end

function Signal.is(object)
	return type(object) == "table" and getmetatable(object) == Signal
end

function Signal.new(): Signal
	return setmetatable({}, Signal)
end

function Signal.prototype:connect(fn: Proc)
	local connection = setmetatable({ connected = true, _signal = self, _fn = fn }, Connection) :: Connection

	if self._last then
		(connection :: AnyConnection & { _next: any })._next = self._last
	end
	self._last = connection

	return connection
end

-- reference: https://developer.roblox.com/en-us/resources/release-note/Release-Notes-for-531
function Signal.prototype:once(fn: Proc)
	local connection: Connection = nil

	connection = setmetatable({
		connected = true,
		_signal = self,
		_fn = function(...)
			connection:disconnect()

			fn(...)
		end,
	}, Connection)

	if self._last then
		(connection :: AnyConnection & { _next: any })._next = self._last
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

function Signal.prototype:wait()
	local waitingCoroutine = coroutine.running()

	local connection: Connection = nil
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

table.freeze(Signal)
table.freeze(Signal.prototype)

return Signal :: SignalConstructor
