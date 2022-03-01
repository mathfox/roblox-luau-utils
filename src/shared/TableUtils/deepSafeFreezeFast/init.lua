local safeFreezeFast = require(script.Parent.safeFreezeFast)
local Types = require(script.Parent.Types)

local function deepSafeFreezeFast(tbl: Types.GenericTable)
	safeFreezeFast(tbl)

	for _, v in pairs(tbl) do
		if type(v) == "table" then
			deepSafeFreezeFast(v)
		end
	end
end

return deepSafeFreezeFast
