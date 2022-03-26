local function getRandomFloat(min: number, maxOrRngOverride: (number | Random)?, rngOverride: Random?)
	return if type(maxOrRngOverride) == "number"
		then (rngOverride or Random.new()):NextNumber(min, maxOrRngOverride)
		else (maxOrRngOverride or Random.new()):NextNumber(0, min)
end

return getRandomFloat
