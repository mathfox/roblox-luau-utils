local Vector3Utils = {
	getDistancePassedInTime = require(script.getDistancePassedInTime),
	getPositionAtTime = require(script.getPositionAtTime),
	getVelocityAtTime = require(script.getVelocityAtTime),
}

table.freeze(Vector3Utils)

return Vector3Utils
