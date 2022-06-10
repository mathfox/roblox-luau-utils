local Types = require(script.Parent.Parent.Types)

type Record<K, V = K> = Types.Record<K, V>

local function length(source: Record<any>)
	local l = 0

	for _ in source do
		l += 1
	end

	return l
end

return length
