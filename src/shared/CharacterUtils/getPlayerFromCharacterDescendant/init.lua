--!strict

local Players = game:GetService("Players")

local getPlayerFromCharacterDescendant = setmetatable({
	method = function(descendant: Instance)
		return Players:GetPlayerFromCharacter(descendant)
	end,
}, {
	__call = function(self, descendant: Instance): Player?
		while descendant.Parent do
			local player: Player? = self.method(descendant.Parent)
			if player then
				return player :: Player
			end

			descendant = descendant.Parent
		end

		return nil
	end,
})

return getPlayerFromCharacterDescendant :: typeof(setmetatable({}, getmetatable(getPlayerFromCharacterDescendant)))
