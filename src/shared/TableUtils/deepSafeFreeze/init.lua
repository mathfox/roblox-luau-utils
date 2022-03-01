local deepSafeFreezeFast = require(script.Parent.deepSafeFreezeFast)
local Types = require(script.Parent.Types)

local function deepSafeFreeze(tbl: Types.GenericTable)
	if tbl == nil then
		error("missing argument #1 to 'deepSafeFreeze' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'deepSafeFreeze' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	deepSafeFreezeFast(tbl)
end

return deepSafeFreeze
