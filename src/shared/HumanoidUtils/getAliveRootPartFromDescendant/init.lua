local getAliveHumanoidFromDescendant = require(script.Parent.getAliveHumanoidFromDescendant)

local function getAliveRootPartFromDescendant(descendant: Instance)
	local humanoid = getAliveHumanoidFromDescendant(descendant)
	return if humanoid then humanoid.RootPart else nil
end

return getAliveRootPartFromDescendant
