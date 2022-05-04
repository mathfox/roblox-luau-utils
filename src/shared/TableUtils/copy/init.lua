local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function copy<K, V>(source: Record<K, V>): Record<K, V>
	local result = table.create(#source)
	for key, value in pairs(source) do
		result[key] = if type(value) == "table" then copy(value) else value
	end
	return result
end

return copy
