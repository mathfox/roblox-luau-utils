local InstanceUtils = {
	findFirstDescendantOfClass = require(script.findFirstDescendantOfClass),
	findFirstDescendantWhichIsA = require(script.findFirstDescendantWhichIsA),

	getChildrenOfClass = require(script.getChildrenOfClass),
	getChildrenWhichIsA = require(script.getChildrenWhichIsA),
	getDescendantsOfClass = require(script.getDescendantsOfClass),
	getDescendantsWhichIsA = require(script.getDescendantsWhichIsA),

	waitForChildOfClass = require(script.waitForChildOfClass),
	waitForChildWhichIsA = require(script.waitForChildWhichIsA),
	waitForDescendantOfClass = require(script.waitForDescendantOfClass),
	waitForDescendantWhichIsA = require(script.waitForDescendantWhichIsA),

	waitUntilParentedTo = require(script.waitUntilParentedTo),

	clearAllChildrenOfClass = require(script.clearAllChildrenOfClass),
	clearAllChildrenWhichIsA = require(script.clearAllChildrenWhichIsA),
	clearAllDescendantsOfClass = require(script.clearAllDescendantsOfClass),
	clearAllDescendantsWhichIsA = require(script.clearAllDescendantsWhichIsA),

	getPVInstanceMass = require(script.getPVInstanceMass),
}

return InstanceUtils
