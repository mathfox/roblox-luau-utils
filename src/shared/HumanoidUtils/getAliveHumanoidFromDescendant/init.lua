local getAliveHumanoidFromDescendantFast = require(script.Parent.getAliveHumanoidFromDescendantFast)

local function getAliveHumanoidFromDescendant(descendant: Instance): Humanoid?
	if descendant == nil then
		error("missing argument #1 to 'getAliveHumanoidFromDescendant' (Instance expected)", 2)
	elseif typeof(descendant) ~= "Instance" then
		error(
			("invalid argument #1 to 'getAliveHumanoidFromDescendant' (Instance expected, got %s)"):format(
				typeof(descendant)
			),
			2
		)
	end

	return getAliveHumanoidFromDescendantFast(descendant)
end

return getAliveHumanoidFromDescendant
