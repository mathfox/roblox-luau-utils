local Types = require(script.Parent.Types)

export type Signal<T...> = Types.Signal<T...>
export type Connection = Types.Connection

local freeRunnerThread: thread? = nil
local runEventHandlerInFreeThread = nil

do
	local function acquireRunnerThreadAndCallEventHandler(fn: (...any) -> (), ...)
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

local function outputHelper(...)
	local length = select("#", ...)
	local tbl: Array<string> = table.create(length)

	for index = 1, length do
		local value = select(index, ...)
		table.insert(tbl, ('"%s": %s'):format(tostring(value), typeof(value)))
	end

	return table.concat(tbl, ", ")
end

local Connection = {} :: Connection & {
	_signal: Signal<...any> & { _last: (Connection & { _next: Connection? })? },
	_fn: (...any) -> (),
}
Connection.connected = true
Connection.__index = Connection

function Connection:__tostring()
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

local Signal = {} :: Signal<...any> & {
	_last: (Connection & { _next: Connection? })?,
}
Signal.__index = Signal

function Signal:__tostring()
	return "Signal"
end

function Signal:connect(fn: (...any) -> (), ...)
	if select("#", ...) > 0 then
		error(('"connect" method expects exactly one function, got (%s) as well'):format(outputHelper(...)), 2)
	end
	local connection: Connection = setmetatable({ _signal = self, _fn = fn }, Connection)

	if self._last then
		connection._next = self._last
	end
	self._last = connection

	return connection
end

function Signal:fire(...)
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

function Signal:wait(): ...any
	local waitingCoroutine = coroutine.running()

	local connection: Connection = nil
	connection = self:connect(function(...)
		connection:disconnect()

		task.spawn(waitingCoroutine, ...)
	end)

	return coroutine.yield()
end

function Signal:destroy()
	local last = self._last

	while last do
		last.connected = false
		last = last._next
	end

	self._last = nil
end

local SignalExport = {
	is = function(object)
		return type(object) == "table" and getmetatable(object) == Signal
	end,

	new = function()
		return setmetatable({}, Signal) :: Signal<...any>
	end,
}

table.freeze(SignalExport)

return SignalExport :: {
	is: (object: any) -> boolean,
	new: <T...>() -> Signal<T...>,
}
