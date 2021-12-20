local function fromPositionAndSize(position: Vector3, size: number): Region3
	local halfSize = size / 2
	return Region3.new(position - halfSize, position + halfSize)
end

local function fromPositionAndRadius(position: Vector3, radius: number): Region3
	local diameterPadded = 2 * radius
	local size = Vector3.new(diameterPadded, diameterPadded, diameterPadded)
	return fromPositionAndSize(position, size)
end

local Region3Utils = {
	fromPositionAndSize = fromPositionAndSize,
	fromPositionAndRadius = fromPositionAndRadius,
}

return Region3Utils
