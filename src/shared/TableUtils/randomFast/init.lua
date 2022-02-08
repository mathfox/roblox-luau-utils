local Types = require(script.Parent.Types)

local function randomFast(tbl: Types.GenericTable, rngOverride: Random?): any
	return tbl[(rngOverride or Random.new()):NextInteger(1, #tbl)]
end

return randomFast
