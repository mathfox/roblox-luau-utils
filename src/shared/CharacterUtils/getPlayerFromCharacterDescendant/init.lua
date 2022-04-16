local Players = game:GetService("Players")

local function getPlayerFromCharacterDescendant(descendant: Instance)
	if __TEST__ then
		repeat
			descendant = descendant.Parent

			if not descendant then
				return nil
			end

			local player: Instance? = Players:FindFirstChild(descendant.Name)
			if player then
				return player :: Instance
			end
		until false
	else
		repeat
			descendant = descendant.Parent

			if not descendant then
				return nil
			end

			local player: Player? = Players:GetPlayerFromCharacter(descendant)
			if player then
				return player :: Player
			end
		until false
	end
end

return getPlayerFromCharacterDescendant
