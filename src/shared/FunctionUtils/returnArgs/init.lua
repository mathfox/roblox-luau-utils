local function returnArgs<T...>(...: T...): () -> T...
	local length, values = select("#", ...), { ... }
	return function(): T...
		return unpack(values, 1, length)
	end
end

return returnArgs
