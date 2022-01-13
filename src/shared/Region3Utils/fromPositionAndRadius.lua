local fromPositionAndSize = require(script.Parent.fromPositionAndSize)

local function fromPositionAndRadius(position: Vector3, radius: number): Region3
	local diameterPadded: number = 2 * radius

	local size = Vector3.new(diameterPadded, diameterPadded, diameterPadded)

	return fromPositionAndSize(position, size)
end

return fromPositionAndRadius
