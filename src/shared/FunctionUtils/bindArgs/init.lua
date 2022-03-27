-- Returns a function which will receive provided varargs as the first arguments and lastly the arguments provided when it was called.
local function bindArgs<T..., R..., V...>(func: (T..., R...) -> V..., ...: T...): (R...) -> V...
	local length, args = select("#", ...), { ... }
	return function(...: R...): V...
		return func(unpack(args, 1, length), ...)
	end
end

return bindArgs
