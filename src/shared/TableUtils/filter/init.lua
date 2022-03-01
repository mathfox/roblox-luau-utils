local filterFast = require(script.Parent.filterFast)
local Types = require(script.Parent.Types)

local function filter(tbl: Types.GenericTable, predicate: (v: any, k: any, tbl: Types.GenericTable) -> boolean)
	if tbl == nil then
		error("missing argument #1 to 'filter' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'filter' (table expected, got %s)"):format(typeof(tbl)), 2)
	elseif predicate == nil then
		error("missing argument #2 to 'filter' (function expected)", 2)
	elseif type(predicate) ~= "function" then
		error(("invalid argument #2 to 'filter' (function expected, got %s)"):format(typeof(predicate)), 2)
	end

	return filterFast(tbl, predicate)
end

return filter
