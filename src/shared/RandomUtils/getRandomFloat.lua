type NumberOrRandom = number | Random

local function getRandomFloat(min: number, max: NumberOrRandom?, randomOverride: Random?): number
	if min == nil then
		error("missing argument #1 to 'getRandomFloat' (number expected)", 2)
	elseif type(min) ~= "number" then
		error(("invalid argument #1 to 'getRandomFloat' (number expected, got %s)"):format(type(min)), 2)
	end

	if type(max) == "number" then
		return (randomOverride or Random.new()):NextNumber(min, max)
	end

	return (typeof(max) == "Random" and max or Random.new()):NextNumber(0, min)
end

return getRandomFloat
