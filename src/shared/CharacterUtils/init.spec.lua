return function()
	local CharacterUtils = require(script.Parent)

	it("should be a table", function()
		expect(CharacterUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(CharacterUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			CharacterUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(CharacterUtils, {})
		end).to.throw()
	end)

	it("should expose known APIs", function()
		local knownAPIs = {
			getAlivePlayerHumanoid = "function",
			getAlivePlayerRootPart = "function",
			getPlayerFromCharacterDescendant = "table",
			getPlayerHumanoid = "function",
			getPlayerRootPart = "function",
			unequipPlayerTools = "function",
		}

		expect(function()
			for key, value in CharacterUtils do
				assert(knownAPIs[key] ~= nil)
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
