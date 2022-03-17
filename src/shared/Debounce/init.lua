local Enumerator = require(script.Parent.Enumerator)
local Types = require(script.Types)

local Debounce = {}
Debounce.Type = Enumerator("DebounceType", { "Once", "Time" })
Debounce.prototype = {}
Debounce.__index = Debounce.prototype

function Debounce:__call(...)
	return self:Invoke(...)
end

function Debounce.is(object)
	return type(object) == "table" and getmetatable(object) == Debounce
end

function Debounce.once(successFunction: (...any) -> ...any, failFunction: ((...any) -> ...any)?): Types.Debounce
	return setmetatable({
		type = Debounce.Type.Once,
		_successFunction = successFunction,
		_failFunction = failFunction,
	}, Debounce)
end

function Debounce.time(
	debounceTime: number,
	successFunction: (...any) -> ...any,
	failFunction: ((...any) -> ...any)?
): Types.Debounce
	return setmetatable({
		type = Debounce.Type.Time,
		_debounceTime = debounceTime,
		_successFunction = successFunction,
		_failFunction = failFunction,
	}, Debounce)
end

function Debounce.prototype:Invoke(...)
	if self.type == Debounce.Type.Once then
		if self._lastInvokeTime then
			return self._failFunction and self._failFunction(...)
		end

		self._lastInvokeTime = os.clock()

		return self._successFunction(...)
	elseif self.type == Debounce.Type.Time then
		local invokeTime, lastInvokeTime = os.clock(), self._lastInvokeTime
		if lastInvokeTime and (invokeTime - lastInvokeTime < self._debounceTime) then
			return self._failFunction and self._failFunction(...)
		end

		self._lastInvokeTime = invokeTime

		return self._successFunction(...)
	end
end

function Debounce.prototype:Unbounce()
	if self.type == Debounce.Type.Once then
		self._lastInvokeTime = nil
	elseif self.type == Debounce.Type.Time then
		self._lastInvokeTime = 0
	end
end

function Debounce.prototype:Destroy()
	self._lastInvokeTime = nil
end

Debounce.prototype.invoke = Debounce.prototype.Invoke
Debounce.prototype.destroy = Debounce.prototype.Destroy
Debounce.prototype.unbounce = Debounce.prototype.Unbounce

return Debounce
