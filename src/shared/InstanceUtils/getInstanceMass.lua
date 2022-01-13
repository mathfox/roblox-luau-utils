local getDescendantsWhichIsA = require(script.Parent.getDescendantsWhichIsA)

local function getInstanceMass(instance: BasePart | Model): number
	if instance:IsA("BasePart") then
		return instance:GetMass()
	elseif instance:IsA("Model") then
		local totalMass: number = 0

		for _, descendant in ipairs(getDescendantsWhichIsA(instance, "BasePart")) do
			totalMass += descendant:GetMass()
		end

		return totalMass
	else
		error(("unknown className '%s'"):format(instance.ClassName), 2)
	end
end

return getInstanceMass
