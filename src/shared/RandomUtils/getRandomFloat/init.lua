local getRandomFloatFast = require(script.Parent.getRandomFloatFast)
local Types = require(script.Parent.Types)

local function getRandomFloat(min: number, maxOrRngOverride: Types.NumberOrRandom?, rngOverride: Random?): number
	if min == nil then
		error("missing argument #1 to 'getRandomFloat' (number expected)", 2)
	elseif type(min) ~= "number" then
		error(("invalid argument #1 to 'getRandomFloat' (number expected, got %s)"):format(type(min)), 2)
	end

	return getRandomFloatFast(min, maxOrRngOverride, rngOverride)
end

return getRandomFloat
