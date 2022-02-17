local scaleModelFast = require(script.Parent.scaleModelFast)

local function scaleModel(model: Model, scaleNumber: number)
	if model == nil then
		error("missing argument #1 to 'scaleModel' (Model expected)", 2)
	elseif typeof(model) ~= "Instance" then
		error(("invalid argument #1 to 'scaleModel' (Model expected, got %s)"):format(typeof(model)), 2)
	elseif not model:IsA("Model") then
		error(("invalid argument #1 to 'scaleModel' (Model expected, got %s)"):format(model.ClassName), 2)
	elseif scaleNumber == nil then
		error("missing argument #2 to 'scaleModel' (number expected)", 2)
	elseif type(scaleNumber) ~= "number" then
		error(("invalid argument #2 to 'scaleModel' (number expected, got %s)"):format(type(scaleNumber)), 2)
	elseif math.abs(scaleNumber) == math.huge then
		error("invalid argument #2 to 'scaleModel' (not infinite number expected, got infinite number)", 2)
	end

	scaleModelFast(model, scaleNumber)
end

return scaleModel
