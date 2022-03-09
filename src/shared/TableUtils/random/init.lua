local Types = require(script.Parent.Types)

local function random(tbl: Types.GenericTable, rngOverride: Random?)
	return tbl[(rngOverride or Random.new()):NextInteger(1, #tbl)]
end

return random
