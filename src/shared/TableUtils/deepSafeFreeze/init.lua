local safeFreeze = require(script.Parent.safeFreeze)
local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function deepSafeFreeze(source: Record<any, any>)
	safeFreeze(source)
	for _, value in pairs(source) do
		if type(value) == "table" then
			deepSafeFreeze(value)
		end
	end
end

return deepSafeFreeze
