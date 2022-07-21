-- Returns a new function which will receive provided varargs as the first arguments and lastly the arguments provided when it was called.
local function bindArgs<R..., V...>(f: (...any) -> V..., ...): (R...) -> V...
	local length, values = select("#", ...), { ... }

	return function(...: R...): V...
		return f(unpack(values, 1, length), ...)
	end
end

return bindArgs
