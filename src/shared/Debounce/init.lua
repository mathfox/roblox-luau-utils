local Debounce = {}
Debounce.prototype = {}
Debounce.__index = Debounce.prototype

function Debounce.is(object: any): boolean
	return type(object) == "table" and getmetatable(object) == Debounce
end

function Debounce.once(successFunction: ((...any) -> ...any), failFunction: ((...any) -> ...any)?)
	if type(successFunction) ~= "function" then
		error("#1 argument must be a function!", 2)
	elseif type(failFunction) ~= "function" and failFunction ~= nil then
		error("#2 argument must be a function or nil!", 2)
	end

	local self = setmetatable({}, Debounce)

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

	local self = setmetatable({}, Debounce)

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

function Debounce.prototype:_updateLastInvokeTime(invokeTime: number)
	self._lastInvokeTime = invokeTime
end

function Debounce.prototype:_getLastInvokeTime(): number?
	return self._lastInvokeTime
end

function Debounce.prototype:Destroy()
	self._lastInvokeTime = nil
end

return Debounce
