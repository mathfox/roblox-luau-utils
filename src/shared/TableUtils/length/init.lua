local lengthFast = require(script.Parent.lengthFast)
local Types = require(script.Parent.Types)

local function length(tbl: Types.GenericTable)
	if tbl == nil then
		error("missing argument #1 to 'length' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'length' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	return lengthFast(tbl)
end

return length
