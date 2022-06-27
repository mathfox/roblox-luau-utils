local function getDistancePassedInTime(time: number, initialVelocity: Vector3, acceleration: Vector3)
	local timePow2 = time ^ 2

	return (initialVelocity * time) + Vector3.new((acceleration.X * timePow2) / 2, (acceleration.Y * timePow2) / 2, (acceleration.Z * timePow2) / 2)
end

return getDistancePassedInTime
