local Types = require(script.Parent.Parent.Types)

type Record<K, V = K> = Types.Record<K, V>

local function join(...: Record<any>?): Record<any>
	local result = {}

	for index = 1, select("#", ...) do
		local source = select(index, ...)
		if source ~= nil then
			for key, value in source do
				result[key] = value
			end
		end
	end

	return result
end

return join
