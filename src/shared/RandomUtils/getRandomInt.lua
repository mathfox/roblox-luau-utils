type NumberOrRandom = number | Random

local function getRandomInt(min: number, max: NumberOrRandom?, randomOverride: Random?): number
	if min == nil then
		error("missing argument #1 to 'getRandomInt' (number expected)", 2)
	elseif type(min) ~= "number" then
		error(("invalid argument #1 to 'getRandomInt' (number expected, got %s)"):format(type(min)), 2)
	end

	if type(max) == "number" then
		return (randomOverride or Random.new()):NextInteger(min, max)
	end

	return (typeof(max) == "Random" and max or Random.new()):NextInteger(0, min)
end

return getRandomInt
