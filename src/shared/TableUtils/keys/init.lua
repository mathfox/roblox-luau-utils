local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>
type Array<T> = Types.Array<T>

local function keys<K>(source: Record<K, any>): Array<K>
	local result = table.create(#source)
	for key in pairs(source) do
		table.insert(result, key)
	end
	return result
end

return keys
