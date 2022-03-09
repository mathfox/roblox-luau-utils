local Types = require(script.Parent.Types)

local function getRandomInt(min: number, maxOrRngOverride: Types.NumberOrRandom?, rngOverride: Random?)
	return if type(maxOrRngOverride) == "number"
		then (rngOverride or Random.new()):NextInteger(min, maxOrRngOverride)
		else (maxOrRngOverride or Random.new()):NextInteger(0, min)
end

return getRandomInt
