local Types = require(script.Parent.Parent.Types)

type Record<K, V = K> = Types.Record<K, V>

local function override(target: Record<any>, source: Record<any>): Record<any>
	local result = table.clone(target)

	for key, value in source do
		result[key] = if type(value) == "table" then if type(result[key]) == "table" then override(result[key], value) else table.clone(value) else value
	end

	return result
end

return override
