return function()
	local HttpService = game:GetService("HttpService")
	local Players = game:GetService("Players")

	local getPlayerFromCharacterDescendant = require(script.Parent)

	getPlayerFromCharacterDescendant.method = function(descendant: Instance)
		return Players:FindFirstChild(descendant.Name)
	end

	it("should be a table", function()
		expect(getPlayerFromCharacterDescendant).to.be.a("table")
	end)

	it("should contain a metatable with __call metamethod", function()
		local meta = getmetatable(getPlayerFromCharacterDescendant)

		expect(meta).to.be.a("table")

		for key, value in meta do
			assert(key == "__call" and type(value) == "function")
		end
	end)

	it('should expose hidden "method" function', function()
		expect(getPlayerFromCharacterDescendant.method).to.be.a("function")
	end)

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
