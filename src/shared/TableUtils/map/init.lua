local mapFast = require(script.Parent.mapFast)
local Types = require(script.Parent.Types)

local function map(tbl: Types.GenericTable, func: (v: any, k: any, tbl: Types.GenericTable) -> any)
	if tbl == nil then
		error("missing argument #1 to 'map' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'map' (table expected, got %s)"):format(typeof(tbl)), 2)
	elseif func == nil then
		error("missing argument #2 to 'map' (function expected)", 2)
	elseif type(func) ~= "function" then
		error(("invalid argument #2 to 'map' (function expected, got %s)"):format(typeof(func)), 2)
	end

	return mapFast(tbl, func)
end

return map
