local getAliveHumanoidFromModel = require(script.Parent.getAliveHumanoidFromModel)

local function getAliveRootPartFromModel(model: Model)
	local humanoid = getAliveHumanoidFromModel(model)
	return if humanoid then humanoid.RootPart else nil
end

return getAliveRootPartFromModel
