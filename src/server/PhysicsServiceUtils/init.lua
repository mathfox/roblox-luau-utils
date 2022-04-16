local PhysicsServiceUtils = {
	createCollisionGroupIfNotCreated = require(script.createCollisionGroupIfNotCreated),
	doesCollisionGroupWithNameExist = require(script.doesCollisionGroupWithNameExist),
	doesCollisionGroupWithIdExist = require(script.doesCollisionGroupWithIdExist),
}

table.freeze(PhysicsServiceUtils)

return PhysicsServiceUtils
