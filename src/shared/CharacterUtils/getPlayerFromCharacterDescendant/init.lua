local getPlayerFromCharacterDescendantFast = require(script.Parent.getPlayerFromCharacterDescendantFast)

local function getPlayerFromCharacterDescendant(descendant: Instance): Player?
	if descendant == nil then
		error("missing argument #1 to 'getPlayerFromCharacterDescendant' (Instance expected)", 2)
	elseif typeof(descendant) ~= "Instance" then
		error(
			("invalid argument #1 to 'getPlayerFromCharacterDescendant' (Instance expected, got %s)"):format(
				typeof(descendant)
			),
			2
		)
	end

	return getPlayerFromCharacterDescendantFast(descendant)
end

return getPlayerFromCharacterDescendant
