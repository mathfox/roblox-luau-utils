return function()
	local HttpService = game:GetService("HttpService")
	local Players = game:GetService("Players")
	local getPlayerFromCharacterDescendant = require(script.Parent)

	getPlayerFromCharacterDescendant.method = function(descendant: Instance)
		return Players:FindFirstChild(descendant.Name)
	end

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

			preudoPlayersFolder:Destroy()
			player:Destroy()
		end).never.to.throw()
	end)
end
