local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function map<K, V>(source: Record<K, V>, func: (V, K, Record<K, V>) -> any): Record<K, any>
	local result = table.create(#source)
	for key, value in pairs(source) do
		result[key] = func(value, key, source)
	end
	return result
end

return map
