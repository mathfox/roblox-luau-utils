local function getRandomCFrameFromBasePart(part: BasePart, rngOverride: Random?): CFrame
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

local function convertBasePartToRegion3(part: BasePart): Region3
	local new, abs = Vector3.new, math.abs
	local size = part.Size
	local sX, sY, sZ = size.X, size.Y, size.Z

	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = part.CFrame:GetComponents()

	local wsX = 0.5 * (abs(R00) * sX + abs(R01) * sY + abs(R02) * sZ)
	local wsY = 0.5 * (abs(R10) * sX + abs(R11) * sY + abs(R12) * sZ)
	local wsZ = 0.5 * (abs(R20) * sX + abs(R21) * sY + abs(R22) * sZ)

	local minX, minY, minZ = x - wsX, y - wsY, z - wsZ
	local maxX, maxY, maxZ = x + wsX, y + wsY, z + wsZ

	return Region3.new(new(minX, minY, minZ), new(maxX, maxY, maxZ))
end

local BasePartUtils = {
	getRandomCFrameFromBasePart = getRandomCFrameFromBasePart,
	GetRandomCFrameFromBasePart = getRandomCFrameFromBasePart,
	convertPartToRegion3 = convertBasePartToRegion3,
	ConvertPartToRegion3 = convertBasePartToRegion3,
}

return BasePartUtils
