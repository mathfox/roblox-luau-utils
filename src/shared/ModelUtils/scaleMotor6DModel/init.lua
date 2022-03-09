local getChildrenWhichIsA = require(script.Parent.Parent.InstanceUtils.getChildrenWhichIsA)

local function scaleMotor6DModel(model: Model, scaleNumber: number)
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
