local getAliveHumanoidFromModelFast = require(script.Parent.getAliveHumanoidFromModelFast)

local function getAliveHumanoidFromModel(model: Model): Humanoid?
	if model == nil then
		error("missing argument #1 to 'getAliveHumanoidFromModel' (Model expected)", 2)
	elseif typeof(model) ~= "Instance" or not model:IsA("Model") then
		error(("invalid argument #1 to 'getAliveHumanoidFromModel' (Model expected, got %s)"):format(typeof(model)), 2)
	end

	return getAliveHumanoidFromModelFast(model)
end

return getAliveHumanoidFromModel
