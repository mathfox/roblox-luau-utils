local function getRandomInt(min: number, maxOrRngOverride: (number | Random)?, rngOverride: Random?)
	return if type(maxOrRngOverride) == "number" then (rngOverride or Random.new()):NextInteger(min, maxOrRngOverride) else (maxOrRngOverride or Random.new()):NextInteger(0, min)
end

return getRandomInt
