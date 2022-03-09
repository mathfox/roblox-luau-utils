local Players = game:GetService("Players")

local function getPlayerFromCharacterDescendantFast(descendant: Instance)
	local character = descendant

	while character do
		local player: Player? = Players:GetPlayerFromCharacter(character)
		if player then
			return player :: Player
		else
			character = character.Parent
		end
	end

	return nil
end

return getPlayerFromCharacterDescendantFast
