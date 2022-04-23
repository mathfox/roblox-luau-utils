return function()
	local CharacterUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			CharacterUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(CharacterUtils, {})
		end).to.throw()
	end)
end
