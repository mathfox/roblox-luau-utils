local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function length(source: Record<any, any>)
	local l = 0
	for _ in pairs(source) do
		l += 1
	end
	return l
end

return length
