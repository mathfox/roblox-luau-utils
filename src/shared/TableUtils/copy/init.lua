local copyFast = require(script.Parent.copyFast)
local Types = require(script.Parent.Types)

local function copy(tbl: Types.GenericTable): Types.GenericTable
	if tbl == nil then
		error("missing argument #1 to 'copy' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'copy' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	return copyFast(tbl)
end

return copy
