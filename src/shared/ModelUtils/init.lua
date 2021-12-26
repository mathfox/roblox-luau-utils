local InstanceUtils = require(script.Parent.InstanceUtils)

local function scaleModel(model: Model, scaleNumber: number)
	if typeof(model) ~= "Instance" or not model:IsA("Model") then
		error("#1 argument must be a Model!", 2)
	elseif type(scaleNumber) ~= "number" then
		error("#2 argument must be a number!", 2)
	end

	local primaryPart = model.PrimaryPart
	local primaryCFrame = primaryPart.CFrame
	local inversedCFrame = primaryCFrame:Inverse()

	local baseParts = InstanceUtils.getDescendantsOfClass(model, "BasePart")
	for _, part in ipairs(baseParts) do
		part.Size *= scaleNumber
		if part ~= primaryPart then
			part.CFrame = primaryCFrame + (inversedCFrame * part.Position * scaleNumber)
		end
	end
end

local function scaleMotor6DModel(model: Model, scaleNumber: number)
	if typeof(model) ~= "Instance" or not model:IsA("Model") then
		error("#1 argument must be a Model!", 2)
	elseif type(scaleNumber) ~= "number" then
		error("#2 argument must be a number!", 2)
	elseif math.abs(scaleNumber) == math.huge then
		error("#2 argument must be a non-infinite number!")
	end

	local getChildrenOfClass = InstanceUtils.getChildrenOfClass

	local baseParts = getChildrenOfClass(model, "BasePart")
	for _, part in ipairs(baseParts) do
		part.Size *= scaleNumber

		local joints = getChildrenOfClass(part, "JointInstance")
		for _, joint in ipairs(joints) do
			local jointScaleNumber = scaleNumber - 1
			joint.C0 += joint.C0.Position * jointScaleNumber
			joint.C1 += joint.C1.Position * jointScaleNumber
		end
	end
end

local ModelUtils = {
	scaleModel = scaleModel,
	ScaleModel = scaleModel,
	scaleMotor6DModel = scaleMotor6DModel,
	ScaleMotor6DModel = scaleMotor6DModel,
}

return ModelUtils
