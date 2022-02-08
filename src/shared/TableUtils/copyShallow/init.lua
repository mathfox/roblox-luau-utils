local copyShallowFast = require(script.Parent.copyShallowFast)
local Types = require(script.Parent.Types)

local function copyShallow(tbl: Types.GenericTable): Types.GenericTable
	if tbl == nil then
		error("missing argument #1 to 'copyShallow' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'copyShallow' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	return copyShallowFast(tbl)
end

return copyShallow
