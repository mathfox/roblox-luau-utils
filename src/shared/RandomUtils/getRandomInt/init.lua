local getRandomIntFast = require(script.Parent.getRandomIntFast)
local Types = require(script.Parent.Types)

local function getRandomInt(min: number, maxOrRngOverride: Types.NumberOrRandom?, rngOverride: Random?): number
	if min == nil then
		error("missing argument #1 to 'getRandomInt' (number expected)", 2)
	elseif type(min) ~= "number" then
		error(("invalid argument #1 to 'getRandomInt' (number expected, got %s)"):format(type(min)), 2)
	end

	return getRandomIntFast(min, maxOrRngOverride, rngOverride)
end

return getRandomInt
