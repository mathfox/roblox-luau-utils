local DebouncePrototype = require(script.DebouncePrototype)

local Debounce = {}

function Debounce.is(obj: any): boolean
	return type(obj) == "table" and obj.ClassName == DebouncePrototype.ClassName
end

function Debounce.once(successFunction: ((...any) -> ...any), failFunction: ((...any) -> ...any)?)
	if type(successFunction) ~= "function" then
		error("#1 argument must be a function!", 2)
	elseif type(failFunction) ~= "function" and failFunction ~= nil then
		error("#2 argument must be a function or nil!", 2)
	end

	local self = setmetatable({}, DebouncePrototype)

	self.OnInvoke = function(...)
		if self:_getLastInvokeTime() then
			return failFunction and failFunction(...)
		end

		self:_updateLastInvokeTime(os.clock())

		return successFunction(...)
	end

	return self
end

function Debounce.time(debounceTime: number, successFunction: ((...any) -> ...any), failFunction: ((...any) -> ...any)?)
	if type(debounceTime) ~= "number" then
		error("#1 argument must be a number!", 2)
	elseif math.abs(debounceTime) == math.huge or debounceTime <= 0 then
		error("Debounce time must be over zero and not infinity!", 2)
	elseif type(successFunction) ~= "function" then
		error("#2 argument must be a function!", 2)
	elseif type(failFunction) ~= "function" and failFunction ~= nil then
		error("#3 argument must be a function or nil!", 2)
	end

	local self = setmetatable({}, DebouncePrototype)

	self:_updateLastInvokeTime(0)
	self.OnInvoke = function(...)
		local invokeTime = os.clock()
		if invokeTime - self:_getLastInvokeTime() < debounceTime then
			return failFunction and failFunction(...)
		end

		self:_updateLastInvokeTime(invokeTime)

		return successFunction(...)
	end

	return self
end

return Debounce
