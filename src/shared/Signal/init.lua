local Types = require(script.Parent.Types)

type Connection = Types.Connection
type Signal<T...> = Types.Signal<T...>

local freeRunnerThread = nil
local runEventHandlerInFreeThread = nil

do
	local function acquireRunnerThreadAndCallEventHandler(fn, ...)
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
Connection.connected = true
Connection.__index = Connection

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

local Signal = {}
Signal.__index = Signal

function Signal:connect(fn)
	local connection = Connection.new(self, fn)

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

function Signal:wait()
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

return {
	is = function(v)
		return type(v) == "table" and getmetatable(v) == Signal
	end,
	new = function()
		return setmetatable({}, Signal)
	end,
} :: {
	is: (v: any) -> boolean,
	new: () -> Signal,
}
