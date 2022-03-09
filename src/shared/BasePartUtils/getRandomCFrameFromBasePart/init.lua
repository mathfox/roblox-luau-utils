local function getRandomCFrameFromBasePart(part: BasePart, rngOverride: Random?)
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
