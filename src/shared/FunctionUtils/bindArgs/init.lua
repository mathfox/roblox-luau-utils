-- Returns a function which will receive provided varargs as the first arguments and lastly the arguments provided when it was called.
local function bindArgs<R..., V...>(f: (...any) -> V..., ...): (R...) -> V...
	if type(f) ~= "function" then
		error(('"f" (#1 argument) must be a function, got ("%s": %s) instead'):format(tostring(f), typeof(f)), 2)
	end

	local length, values = select("#", ...), { ... }
	return function(...: R...): V...
		return f(unpack(values, 1, length), ...)
	end
end

return bindArgs
