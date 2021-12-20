local DebouncePrototype = {
	ClassName = "DebouncePrototype",
}
DebouncePrototype.__index = DebouncePrototype

function DebouncePrototype:_updateLastInvokeTime(invokeTime: number)
	self._lastInvokeTime = invokeTime
end

function DebouncePrototype:_getLastInvokeTime(): number?
	return self._lastInvokeTime
end

function DebouncePrototype:Destroy()
	self._lastInvokeTime = nil
end

return DebouncePrototype
