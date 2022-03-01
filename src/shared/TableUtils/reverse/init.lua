local reverseFast = require(script.Parent.reverseFast)
local Types = require(script.Parent.Types)

local function reverse(tbl: Types.GenericTable)
	if tbl == nil then
		error("missing argument #1 to 'reverse' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'reverse' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	return reverseFast(tbl)
end

return reverse
