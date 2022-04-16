local HumanoidUtils = {
	getAliveRootPartFromDescendant = require(script.getAliveRootPartFromDescendant),
	getAliveHumanoidFromDescendant = require(script.getAliveHumanoidFromDescendant),
	teleportHumanoidToPosition = require(script.teleportHumanoidToPosition),
	getAliveHumanoidFromModel = require(script.getAliveHumanoidFromModel),
	getAliveRootPartFromModel = require(script.getAliveRootPartFromModel),
	teleportHumanoidToCFrame = require(script.teleportHumanoidToCFrame),
	scaleHumanoid = require(script.scaleHumanoid),
	healHumanoid = require(script.healHumanoid),
}

table.freeze(HumanoidUtils)

return HumanoidUtils
