local Enumerator = require(script.Parent.Enumerator)
local Types = require(script.Parent.Types)

type EnumeratorItem<T> = Types.EnumeratorItem<T>
type Enumerator<T> = Types.Enumerator<T>
export type Debounce = Types.Debounce

local DebounceExport = {
	Type = Enumerator("Debounce.Type", { "Once", "Time" }),
}

local Debounce = {} :: Debounce & {
	_successFunction: (...any) -> (...any),
	_failFunction: ((...any) -> ...any)?,
	_debounceTime: number?,
	_lastInvokeTime: number,
}

Debounce.__index = Debounce

function Debounce:__call(...)
	return self:invoke(...)
end

function Debounce:invoke(...)
	if self.type == DebounceExport.Type.Once then
		if self._lastInvokeTime then
			return if self._failFunction then self._failFunction(...) else nil
		end

		self._lastInvokeTime = os.clock()

		return self._successFunction(...)
	elseif self.type == DebounceExport.Type.Time then
		local invokeTime, lastInvokeTime = os.clock(), self._lastInvokeTime
		if lastInvokeTime and (invokeTime - lastInvokeTime < self._debounceTime :: number) then
			return if self._failFunction then self._failFunction(...) else nil
		end

		self._lastInvokeTime = invokeTime

		return self._successFunction(...)
	end
end

function Debounce:unbounce()
	if self.type == DebounceExport.Type.Once then
		self._lastInvokeTime = nil
	elseif self.type == DebounceExport.Type.Time then
		self._lastInvokeTime = 0
	end
end

function Debounce:destroy()
	self._lastInvokeTime = nil
end

function DebounceExport.is(object)
	return type(object) == "table" and getmetatable(object) == Debounce
end

function DebounceExport.once(successFunction: (...any) -> ...any, failFunction: ((...any) -> ...any)?)
	return setmetatable({
		type = DebounceExport.Type.Once,
		_successFunction = successFunction,
		_failFunction = failFunction,
	}, Debounce) :: Debounce
end

function DebounceExport.time(debounceTime: number, successFunction: (...any) -> ...any, failFunction: ((...any) -> ...any)?)
	return setmetatable({
		type = DebounceExport.Type.Time,
		_debounceTime = debounceTime,
		_successFunction = successFunction,
		_failFunction = failFunction,
	}, Debounce) :: Debounce
end

table.freeze(DebounceExport)

return DebounceExport :: {
	Type: Enumerator<string> & { Once: EnumeratorItem<string>, Time: EnumeratorItem<string> },
	is: (object: any) -> boolean,
	once: (successFunction: (...any) -> ...any, failFunction: ((...any) -> ...any)?) -> Debounce,
	time: (debounceTime: number, successFunction: (...any) -> ...any, failFunction: ((...any) -> ...any)?) -> Debounce,
}
