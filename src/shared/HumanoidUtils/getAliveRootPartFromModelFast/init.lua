local getAliveHumanoidFromModelFast = require(script.Parent.getAliveHumanoidFromModelFast)

local function getAliveRootPartFromModelFast(model: Model): BasePart?
	local humanoid = getAliveHumanoidFromModelFast(model)
	return if humanoid then humanoid.RootPart else nil
end

return getAliveRootPartFromModelFast
