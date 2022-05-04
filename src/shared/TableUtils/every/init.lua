local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function every<K, V>(source: Record<K, V>, predicate: (V, K, Record<K, V>) -> boolean)
	for key, value in pairs(source) do
		if not predicate(value, key, source) then
			return false
		end
	end
	return true
end

return every
