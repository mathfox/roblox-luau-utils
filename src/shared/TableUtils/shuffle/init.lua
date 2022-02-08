local shuffleFast = require(script.Parent.shuffleFast)
local Types = require(script.Parent.Types)

local function shuffle(tbl: Types.GenericTable, rngOverride: Random?): Types.GenericTable
	if tbl == nil then
		error("missing argument #1 to 'shuffle' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'shuffle' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	return shuffleFast(tbl, rngOverride)
end

return shuffle
