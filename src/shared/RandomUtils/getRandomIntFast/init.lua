local Types = require(script.Parent.Types)

local function getRandomIntFast(min: number, maxOrRngOverride: Types.NumberOrRandom?, rngOverride: Random?): number
	return if type(maxOrRngOverride) == "number"
		then (rngOverride or Random.new()):NextInteger(min, maxOrRngOverride)
		else (maxOrRngOverride or Random.new()):NextInteger(0, min)
end

return getRandomIntFast
