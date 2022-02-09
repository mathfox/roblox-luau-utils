local getDescendantsWhichIsA = require(script.Parent.getDescendantsWhichIsA)

local function getPVInstanceMass(instance: PVInstance): number
	if instance == nil then
		error("missing argument #1 to 'getPVInstanceMass' (PVInstance expected)", 2)
	elseif typeof(instance) ~= "Instance" or not instance:IsA("PVInstance") then
		error(("invalid argument #1 to 'getPVInstanceMass' (PVInstance expected, got %s)"):format(typeof(instance)), 2)
	end

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

return getPVInstanceMass
