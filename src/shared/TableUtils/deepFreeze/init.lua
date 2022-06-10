local Types = require(script.Parent.Parent.Types)

type Record<K, V = K> = Types.Record<K, V>

local function deepFreeze(target: Record<any>)
	table.freeze(target)

	for _, source in target do
		if type(source) == "table" then
			deepFreeze(source)
		end
	end
end

return deepFreeze
