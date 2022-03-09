local getAliveHumanoidFromModel = require(script.Parent.getAliveHumanoidFromModel)

local function getAliveHumanoidFromDescendant(descendant: Instance)
	local model = descendant:FindFirstAncestorWhichIsA("Model")
	return if model then getAliveHumanoidFromModel(model) else nil
end

return getAliveHumanoidFromDescendant
