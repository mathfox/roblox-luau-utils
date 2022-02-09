local getAliveRootPartFromDescendantFast = require(script.Parent.getAliveRootPartFromDescendantFast)

local function getAliveRootPartFromDescendant(descendant: Instance): BasePart?
	if descendant == nil then
		error("missing argument #1 to 'getAliveRootPartFromDescendant' (Instance expected)", 2)
	elseif typeof(descendant) ~= "Instance" then
		error(
			("invalid argument #1 to 'getAliveRootPartFromDescendant' (Instance expected, got %s)"):format(
				typeof(descendant)
			),
			2
		)
	end

	return getAliveRootPartFromDescendantFast(descendant)
end

return getAliveRootPartFromDescendant
