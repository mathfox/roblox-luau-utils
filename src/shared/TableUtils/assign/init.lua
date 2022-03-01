local assignFast = require(script.Parent.assignFast)
local Types = require(script.Parent.Types)

local function assign(tbl: Types.GenericTable, ...: Types.GenericTable)
	if tbl == nil then
		error("missing argument #1 to 'assign' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'assign' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	return assignFast(tbl, ...)
end

return assign
