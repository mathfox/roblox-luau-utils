local function getRandomCFrameFromBasePart(part: BasePart, rngOverride: Random?)
	local random = if rngOverride then rngOverride :: Random else Random.new()
	local size = part.Size

	local halfSizeX = size.X / 2
	local halfSizeY = size.Y / 2
	local halfSizeZ = size.Z / 2

	return part.CFrame
		* CFrame.new(
			random:NextNumber(-halfSizeX, halfSizeX),
			random:NextNumber(-halfSizeY, halfSizeY),
			random:NextNumber(-halfSizeZ, halfSizeZ)
		)
end

return getRandomCFrameFromBasePart
