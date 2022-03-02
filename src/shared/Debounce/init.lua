local FunctionTypes = require(script.Parent.FunctionUtils.Types)
local CustomEnum = require(script.Parent.CustomEnum)
local Types = require(script.Types)

local Debounce = {}
Debounce.Type = CustomEnum({ "Once", "Time" })
Debounce.prototype = {}
Debounce.__index = Debounce.prototype

function Debounce:__call(...)
	return self:Invoke(...)
end

function Debounce.is(object)
	return type(object) == "table" and getmetatable(object) == Debounce
end

function Debounce.once(
	successFunction: FunctionTypes.GenericFunction,
	failFunction: FunctionTypes.GenericFunction?
): Types.Debounce
	if successFunction == nil then
		error("missing argument #1 to 'once' (function expected)", 2)
	elseif type(successFunction) ~= "function" then
		error(("invalid argument #1 to 'once' (function expected, got %s)"):format(typeof(successFunction)), 2)
	elseif failFunction ~= nil and type(failFunction) ~= "function" then
		error(
			("missing argument #2 to 'once' (either function or nil expected, got %s)"):format(typeof(failFunction)),
			2
		)
	end

	return setmetatable({
		type = Debounce.Type.Once,
		_successFunction = successFunction,
		_failFunction = failFunction,
	}, Debounce)
end

function Debounce.time(
	debounceTime: number,
	successFunction: FunctionTypes.GenericFunction,
	failFunction: FunctionTypes.GenericFunction?
): Types.Debounce
	if debounceTime == nil then
		error("missing argument #1 to 'time' (number expected)", 2)
	elseif type(debounceTime) ~= "number" then
		error(("invalid argument #1 to 'time' (number expected, got %s)"):format(typeof(debounceTime)), 2)
	elseif math.abs(debounceTime) == math.huge or debounceTime <= 0 or debounceTime ~= debounceTime then
		error(
			("invalid argument #1 to 'time' (positive valid number expected, got %s)"):format(tostring(debounceTime)),
			2
		)
	elseif successFunction == nil then
		error("missing argument #2 to 'time' (function expected)", 2)
	elseif type(successFunction) ~= "function" then
		error(("invalid argument #2 to 'time' (function expected, got %s)"):format(typeof(successFunction)), 2)
	elseif failFunction ~= nil and type(failFunction) ~= "function" then
		error(
			("missing argument #3 to 'time' (either function or nil expected, got %s)"):format(typeof(failFunction)),
			2
		)
	end

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
