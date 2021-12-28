local function getRandomCFrameFromBasePart(part: BasePart, rngOverride: Random?): CFrame
	if part == nil then
		error("missing argument #1 to 'getRandomCFrameFromBasePart' (BasePart expected)", 2)
	elseif typeof(part) ~= "Instance" or not part:IsA("BasePart") then
		error(
			("invalid argument #1 to 'getRandomCFrameFromBasePart' (BasePart expected, got %s)"):format(typeof(part)),
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

	local random = rngOverride or Random.new()
	local size = part.Size

	local halfSizeX = size.X / 2
	local halfSizeY = size.Y / 2
	local halfSizeZ = size.Z / 2

	local randomX = random:NextNumber(-halfSizeX, halfSizeX)
	local randomY = random:NextNumber(-halfSizeY, halfSizeY)
	local randomZ = random:NextNumber(-halfSizeZ, halfSizeZ)

	return part.CFrame * CFrame.new(randomX, randomY, randomZ)
end

return getRandomCFrameFromBasePart
