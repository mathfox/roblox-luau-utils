local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function join(...: Record<any, any>?): Record<any, any>
	local result = {}
	for index = 1, select("#", ...) do
		local source = select(index, ...)
		if source ~= nil then
			for key, value in pairs(source) do
				result[key] = value
			end
		end
	end
	return result
end

return join
