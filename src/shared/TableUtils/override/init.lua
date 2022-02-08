local overrideFast = require(script.Parent.overrideFast)
local Types = require(script.Parent.Types)

local function override(tbl: Types.GenericTable, overridingTbl: Types.GenericTable): Types.GenericTable
	if tbl == nil then
		error("missing argument #1 to 'override' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'override' (table expected, got %s)"):format(typeof(tbl)), 2)
	elseif overridingTbl == nil then
		error("missing argument #2 to 'override' (table expected)", 2)
	elseif type(overridingTbl) ~= "table" then
		error(("invalid argument #2 to 'override' (table expected, got %s)"):format(typeof(overridingTbl)), 2)
	end

	return overrideFast(tbl, overridingTbl)
end

return override
