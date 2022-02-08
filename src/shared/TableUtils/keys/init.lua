local keysFast = require(script.Parent.keysFast)
local Types = require(script.Parent.Types)

local function keys(tbl: Types.GenericTable): Types.GenericTable
	if tbl == nil then
		error("missing argument #1 to 'keys' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'keys' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	return keysFast(tbl)
end

return keys
