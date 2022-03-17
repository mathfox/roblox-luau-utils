local getDescendantsWhichIsA = require(script.Parent.Parent.InstanceUtils.getDescendantsWhichIsA)

local function scaleModel(model: Model, scale: number)
	local primaryPart = model.PrimaryPart
	local primaryCFrame = primaryPart.CFrame
	local inversedCFrame = primaryCFrame:Inverse()

	for _, part in ipairs(getDescendantsWhichIsA(model, "BasePart")) do
		part.Size *= scale

		if part ~= primaryPart then
			part.CFrame = primaryCFrame + (inversedCFrame * part.Position * scale)
		end
	end
end

return scaleModel
