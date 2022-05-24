-- reference: https://create.roblox.com/docs/reference/engine/classes/PhysicsService

local PhysicsServiceUtils = {
	createCollisionGroupIfNotCreated = require(script.createCollisionGroupIfNotCreated),
	doesCollisionGroupWithIdExist = require(script.doesCollisionGroupWithIdExist),
	doesCollisionGroupWithNameExist = require(script.doesCollisionGroupWithNameExist),
}

table.freeze(PhysicsServiceUtils)

return PhysicsServiceUtils
