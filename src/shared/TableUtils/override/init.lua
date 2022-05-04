local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function override(target: Record<any, any>, source: Record<any, any>): Record<any, any>
	local result = table.clone(target)
	for key, value in pairs(source) do
		result[key] = if type(value) == "table" then if type(result[key]) == "table" then override(result[key], value) else table.clone(value) else value
	end
	return result
end

return override
