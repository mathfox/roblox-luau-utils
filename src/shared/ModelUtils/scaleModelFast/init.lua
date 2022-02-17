local getDescendantsWhichIsA = require(script.Parent.Parent.InstanceUtils.getDescendantsWhichIsA)

local function scaleModelFast(model: Model, scaleNumber: number)
	local primaryPart: BasePart = model.PrimaryPart
	local primaryCFrame: CFrame = primaryPart.CFrame
	local inversedCFrame: CFrame = primaryCFrame:Inverse()

	for _, part in ipairs(getDescendantsWhichIsA(model, "BasePart")) do
		part.Size *= scaleNumber

		if part ~= primaryPart then
			part.CFrame = primaryCFrame + (inversedCFrame * part.Position * scaleNumber)
		end
	end
end

return scaleModelFast
