local Types = require(script.Types)

type Debounce = Types.Debounce

local Debounce = {}
Debounce.Type = { Once = "Once", Time = "Time" }
Debounce.prototype = {} :: Debounce & {
	_successFunction: (...any) -> (...any),
	_failFunction: ((...any) -> ...any)?,
	_debounceTime: number?,
	_lastInvokeTime: number,
}
Debounce.__index = Debounce.prototype

function Debounce:__call(...)
	return self:invoke(...)
end

function Debounce.is(object)
	return type(object) == "table" and getmetatable(object) == Debounce
end

function Debounce.once(successFunction: (...any) -> ...any, failFunction: ((...any) -> ...any)?): Debounce
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
): Debounce
	return setmetatable({
		type = Debounce.Type.Time,
		_debounceTime = debounceTime,
		_successFunction = successFunction,
		_failFunction = failFunction,
	}, Debounce)
end

function Debounce.prototype:invoke(...)
	if self.type == Debounce.Type.Once then
		if self._lastInvokeTime then
			return if self._failFunction then self._failFunction(...) else nil
		end

		self._lastInvokeTime = os.clock()

		return self._successFunction(...)
	elseif self.type == Debounce.Type.Time then
		local invokeTime, lastInvokeTime = os.clock(), self._lastInvokeTime
		if lastInvokeTime and (invokeTime - lastInvokeTime < self._debounceTime :: number) then
			return if self._failFunction then self._failFunction(...) else nil
		end

		self._lastInvokeTime = invokeTime

		return self._successFunction(...)
	end
end

function Debounce.prototype:unbounce()
	if self.type == Debounce.Type.Once then
		self._lastInvokeTime = nil
	elseif self.type == Debounce.Type.Time then
		self._lastInvokeTime = 0
	end
end

function Debounce.prototype:destroy()
	self._lastInvokeTime = nil
end

return Debounce :: {
	Type: { Once: string, Time: string },
	is: (object: any) -> boolean,
	once: (successFunction: (...any) -> ...any, failFunction: ((...any) -> ...any)?) -> Debounce,
	time: (
		debounceTime: number,
		successFunction: (...any) -> ...any,
		failFunction: ((...any) -> ...any)?
	) -> Debounce,
}
