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
end
