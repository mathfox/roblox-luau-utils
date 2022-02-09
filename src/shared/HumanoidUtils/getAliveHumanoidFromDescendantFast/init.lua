local getAliveHumanoidFromModelFast = require(script.Parent.getAliveHumanoidFromModelFast)

local function getAliveHumanoidFromDescendantFast(descendant: Instance): Humanoid?
	local model = descendant:FindFirstAncestorWhichIsA("Model")
	return if model then getAliveHumanoidFromModelFast(model) else nil
end

return getAliveHumanoidFromDescendantFast
