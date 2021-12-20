type NumberOrRandom = number | Random

local function getRandomInt(min: number, max: NumberOrRandom?, randomOverride: Random?): number
	if type(min) ~= "number" or min % 1 ~= 0 then
		error("#1 argument must be an integer!", 2)
	end

	if type(max) == "number" then
		return (randomOverride or Random.new()):NextInteger(min, max)
	end

	return (typeof(max) == "Random" and max or Random.new()):NextInteger(0, min)
end

local function getRandomFloat(min: number, max: NumberOrRandom?, randomOverride: Random?): number
	if type(min) ~= "number" then
		error("#1 argument must be a number!", 2)
	end

	if type(max) == "number" then
		return (randomOverride or Random.new()):NextNumber(min, max)
	end

	return (typeof(max) == "Random" and max or Random.new()):NextNumber(0, min)
end

local RandomUtils = {
	int = getRandomInt,
	float = getRandomFloat,
}

return RandomUtils
