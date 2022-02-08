local valuesFast = require(script.Parent.valuesFast)
local Types = require(script.Parent.Types)

local function values(tbl: Types.GenericTable): Types.GenericTable
	if tbl == nil then
		error("missing argument #1 to 'values' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'values' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	return valuesFast(tbl)
end

return values
