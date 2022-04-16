return function()
	local HttpService = game:GetService("HttpService")
	local Players = game:GetService("Players")
	local getPlayerFromCharacterDescendant = require(script.Parent)

	getfenv(getPlayerFromCharacterDescendant).__TEST__ = true

	it("should not return Player from the Character itself", function()
		expect(function()
			local playerName = HttpService:GenerateGUID(false)
			local player = Instance.new("Folder", Players)
			player.Name = playerName

			local preudoPlayersFolder = Instance.new("Folder", workspace)

			local character = Instance.new("Folder", preudoPlayersFolder)
			character.Name = playerName

			assert(getPlayerFromCharacterDescendant(character) == nil)

			local descendant = Instance.new("Folder", character)
			assert(getPlayerFromCharacterDescendant(descendant) == player)
		end).never.to.throw()
	end)
end
