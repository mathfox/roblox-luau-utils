local Types = require(script.Parent.Types)

local function getRandomFloat(min: number, maxOrRngOverride: Types.NumberOrRandom?, rngOverride: Random?)
	return if type(maxOrRngOverride) == "number"
		then (rngOverride or Random.new()):NextNumber(min, maxOrRngOverride)
		else (maxOrRngOverride or Random.new()):NextNumber(0, min)
end

return getRandomFloat
