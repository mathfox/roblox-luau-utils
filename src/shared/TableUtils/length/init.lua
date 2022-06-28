local Types = require(script.Parent.Parent.Types)

type Record<K, V = K> = Types.Record<K, V>

local function length(source: Record<any>)
	local amount = 0

	for _ in source do
		amount += 1
	end

	return amount
end

return length
