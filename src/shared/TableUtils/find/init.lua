local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function find<K, V>(source: Record<K, V>, predicate: (V, K, Record<K, V>) -> boolean)
	for key, value in source do
		if predicate(value, key, source) then
			return value, key
		end
	end

	return nil, nil
end

return find
