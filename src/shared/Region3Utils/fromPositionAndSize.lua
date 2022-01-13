local function fromPositionAndSize(position: Vector3, size: number): Region3
	local halfSize: number = size / 2

	return Region3.new(position - halfSize, position + halfSize)
end

return fromPositionAndSize
