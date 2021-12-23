local Players = game:GetService("Players")

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

	local character = descendant

	while character do
		local player: Player? = Players:GetPlayerFromCharacter(character)
		if player then
			return player
		else
			character = character.Parent
		end
	end

	return nil
end

return getPlayerFromCharacterDescendant
