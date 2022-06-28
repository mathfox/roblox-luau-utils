local Types = require(script.Parent.Parent.Types)

type Record<K, V = K> = Types.Record<K, V>

local function deepSafeFreeze(source: Record<any>)
	if not table.isfrozen(source) then
		table.freeze(source)
	end

	for _, value in source do
		if type(value) == "table" then
			deepSafeFreeze(value)
		end
	end
end

return deepSafeFreeze
