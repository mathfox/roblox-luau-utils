local getDistancePassedInTime = require(script.Parent.getDistancePassedInTime)

local function getPositionAtTime(time: number, origin: Vector3, initialVelocity: Vector3, acceleration: Vector3)
	return origin + getDistancePassedInTime(time, initialVelocity, acceleration)
end

return getPositionAtTime
