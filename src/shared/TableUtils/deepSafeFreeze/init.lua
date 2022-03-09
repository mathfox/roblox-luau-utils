local safeFreeze = require(script.Parent.safeFreeze)
local Types = require(script.Parent.Types)

local function deepSafeFreeze(tbl: Types.GenericTable)
	safeFreeze(tbl)

	for _, v in pairs(tbl) do
		if type(v) == "table" then
			deepSafeFreeze(v)
		end
	end
end

return deepSafeFreeze
