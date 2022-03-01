local extendFast = require(script.Parent.extendFast)
local Types = require(script.Parent.Types)

local function extend(tbl: Types.GenericTable, extension: Types.GenericTable)
	if tbl == nil then
		error("missing argument #1 to 'extend' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'extend' (table expected, got %s)"):format(typeof(tbl)), 2)
	elseif extension == nil then
		error("missing argument #2 to 'extend' (table expected)", 2)
	elseif type(extension) ~= "table" then
		error(("invalid argument #2 to 'extend' (table expected, got %s)"):format(typeof(extension)), 2)
	end

	return extendFast(tbl, extension)
end

return extend
