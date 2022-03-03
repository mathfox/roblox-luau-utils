local FunctionUtilsTypes = require(script.Parent.FunctionUtils.Types)
local Types = require(script.Types)

local freeRunnerThread: thread? = nil
local runEventHandlerInFreeThread = nil

do
	local function acquireRunnerThreadAndCallEventHandler(fn: FunctionUtilsTypes.GenericFunction, ...)
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
Connection.prototype.Connected = true
Connection.__index = Connection.prototype

function Connection.new(signal: Types.Signal, fn: FunctionUtilsTypes.GenericFunction): Types.Connection
	return setmetatable({
		_signal = signal,
		_fn = fn,
	}, Connection)
end

function Connection.prototype:Disconnect()
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

Connection.prototype.disconnect = Connection.prototype.Disconnect

local Signal = {}
Signal.prototype = {}
Signal.__index = Signal.prototype

function Signal.prototype:Connect(fn: FunctionUtilsTypes.GenericFunction): Types.Connection
	local connection = Connection.new(self, fn)

	if self._last then
		connection._next = self._last
	end

	self._last = connection

	return connection
end

function Signal.prototype:Fire(...: any)
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

function Signal.prototype:Wait(): ...any
	local waitingCoroutine = coroutine.running()

	local connection = nil
	connection = self:Connect(function(...: any)
		connection:Disconnect()

		task.spawn(waitingCoroutine, ...)
	end)

	return coroutine.yield()
end

function Signal.prototype:Destroy()
	local last = self._last

	while last do
		last.Connected = false
		last = last._next
	end

	self._last = nil
end

function Signal.is(object)
	return type(object) == "table" and getmetatable(object) == Signal
end

function Signal.new(): Types.Signal
	return setmetatable({}, Signal)
end

Signal.prototype.fire = Signal.prototype.Fire
Signal.prototype.connect = Signal.prototype.Connect
Signal.prototype.wait = Signal.prototype.Wait
Signal.prototype.destroy = Signal.prototype.Destroy

return Signal
