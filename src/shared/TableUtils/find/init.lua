local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function find<K, V>(source: Record<K, V>, predicate: (V, K, Record<K, V>) -> boolean)
	for k, v in pairs(source) do
		if predicate(v, k, source) then
			return v, k
		end
	end
	return nil, nil
end

return find
