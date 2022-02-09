local getAliveHumanoidFromDescendantFast = require(script.Parent.getAliveHumanoidFromDescendantFast)

local function getAliveRootPartFromDescendantFast(descendant: Instance): BasePart?
	local humanoid = getAliveHumanoidFromDescendantFast(descendant)
	return if humanoid then humanoid.RootPart else nil
end

return getAliveRootPartFromDescendantFast
