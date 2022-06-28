local function scaleModel(model: Model, scale: number)
	local primaryPart = model.PrimaryPart
	local primaryCFrame = primaryPart.CFrame
	local inversedCFrame = primaryCFrame:Inverse()

	for _, part in model:GetDescendants() do
		if part:IsA("BasePart") then
			part.Size *= scale

			if part ~= primaryPart then
				part.CFrame = primaryCFrame + (inversedCFrame * part.Position * scale)
			end
		end
	end
end

return scaleModel
