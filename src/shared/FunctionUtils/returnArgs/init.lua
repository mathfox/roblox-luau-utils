local function returnArgs<T...>(...: T...): () -> T...
	local length, args = select("#", ...), { ... }
	return function(): T...
		return unpack(args, 1, length)
	end
end

return returnArgs
