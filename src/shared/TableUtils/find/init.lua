local findFast = require(script.Parent.findFast)
local Types = require(script.Parent.Types)

local function find(
	tbl: Types.GenericTable,
	predicate: (v: any, k: any, tbl: Types.GenericTable) -> boolean
): (any, any)
	if tbl == nil then
		error("missing argument #1 to 'find' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'find' (table expected, got %s)"):format(typeof(tbl)), 2)
	elseif predicate == nil then
		error("missing argument #2 to 'find' (function expected)", 2)
	elseif type(predicate) ~= "function" then
		error(("invalid argument #2 to 'find' (function expected, got %s)"):format(typeof(predicate)), 2)
	end

	return findFast(tbl, predicate)
end

return find
