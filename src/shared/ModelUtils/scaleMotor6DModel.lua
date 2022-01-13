local getChildrenWhichIsA = require(script.Parent.Parent.InstanceUtils.getChildrenWhichIsA)

local function scaleMotor6DModel(model: Model, scaleNumber: number)
	if model == nil then
		error("missing argument #1 to 'scaleMotor6DModel' (Model expected)", 2)
	elseif typeof(model) ~= "Instance" then
		error(("invalid argument #1 to 'scaleMotor6DModel' (Model expected, got %s)"):format(typeof(model)), 2)
	elseif not model:IsA("Model") then
		error(("invalid argument #1 to 'scaleMotor6DModel' (Model expected, got %s)"):format(model.ClassName), 2)
	elseif scaleNumber == nil then
		error("missing argument #2 to 'scaleMotor6DModel' (number expected)", 2)
	elseif type(scaleNumber) ~= "number" then
		error(("invalid argument #2 to 'scaleMotor6DModel' (number expected, got %s)"):format(type(scaleNumber)), 2)
	elseif math.abs(scaleNumber) == math.huge then
		error("invalid argument #2 to 'scaleMotor6DModel' (not infinite number expected, got infinite number)", 2)
	end

	for _, part in ipairs(getChildrenWhichIsA(model, "BasePart")) do
		part.Size *= scaleNumber

		for _, joint in ipairs(getChildrenWhichIsA(part, "JointInstance")) do
			local jointScaleNumber: number = scaleNumber - 1

			joint.C0 += joint.C0.Position * jointScaleNumber
			joint.C1 += joint.C1.Position * jointScaleNumber
		end
	end
end

return scaleMotor6DModel
