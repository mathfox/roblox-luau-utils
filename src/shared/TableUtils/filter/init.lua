local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function filter<K, V>(source: Record<K, V>, predicate: (V, K, Record<K, V>) -> boolean): Record<K, V>
	local new = {}

	for key, value in source do
		if predicate(value, key, source) then
			new[key] = value
		end
	end

	return new
end

return filter
