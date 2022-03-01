local randomFast = require(script.Parent.randomFast)
local Types = require(script.Parent.Types)

local function random(tbl: Types.GenericTable, rngOverride: Random?)
	if tbl == nil then
		error("missing argument #1 to 'random' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'random' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	return randomFast(tbl, rngOverride)
end

return random
