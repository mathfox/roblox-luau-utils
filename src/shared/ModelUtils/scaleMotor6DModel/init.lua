local function scaleMotor6DModel(model: Model, scale: number)
	for _, part in model:GetChildren() do
		if part:IsA("BasePart") then
			part.Size *= scale

			for _, joint in part:GetChildren() do
				if joint:IsA("JointInstance") then
					local jointScaleNumber = scale - 1

					joint.C0 += joint.C0.Position * jointScaleNumber
					joint.C1 += joint.C1.Position * jointScaleNumber
				end
			end
		end
	end
end

return scaleMotor6DModel
