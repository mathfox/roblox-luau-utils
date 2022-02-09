local getAliveRootPartFromModelFast = require(script.Parent.getAliveRootPartFromModelFast)

local function getAliveRootPartFromModel(model: Model): BasePart?
	if model == nil then
		error("missing argument #1 to 'getAliveRootPartFromModel' (Model expected)", 2)
	elseif typeof(model) ~= "Instance" or not model:IsA("Model") then
		error(("invalid argument #1 to 'getAliveRootPartFromModel' (Model expected, got %s)"):format(typeof(model)), 2)
	end

	return getAliveRootPartFromModelFast(model)
end

return getAliveRootPartFromModel
