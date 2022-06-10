local Types = require(script.Parent.Parent.Types)

local safeFreeze = require(script.Parent.safeFreeze)

type Record<K, V = K> = Types.Record<K, V>

local function deepSafeFreeze(source: Record<any>)
	safeFreeze(source)

	for _, value in source do
		if type(value) == "table" then
			deepSafeFreeze(value)
		end
	end
end

return deepSafeFreeze
