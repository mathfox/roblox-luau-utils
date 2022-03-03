local getRandomCFrameFromBasePartFast = require(script.Parent.getRandomCFrameFromBasePartFast)

local function getRandomCFrameFromBasePart(part: BasePart, rngOverride: Random?)
	if part == nil then
		error("missing argument #1 to 'getRandomCFrameFromBasePart' (BasePart expected)", 2)
	elseif typeof(part) ~= "Instance" then
		error(
			("invalid argument #1 to 'getRandomCFrameFromBasePart' (BasePart expected, got %s)"):format(typeof(part)),
			2
		)
	elseif not part:IsA("BasePart") then
		error(
			("invalid argument #1 to 'getRandomCFrameFromBasePart' (BasePart expected, got %s)"):format(part.ClassName),
			2
		)
	elseif rngOverride ~= nil and typeof(rngOverride) ~= "Random" then
		error(
			("invalid argument #2 to 'getRandomCFrameFromBasePart' (either Random or nil expected, got %s)"):format(
				typeof(rngOverride)
			),
			2
		)
	end

	return getRandomCFrameFromBasePartFast(part, rngOverride)
end

return getRandomCFrameFromBasePart
