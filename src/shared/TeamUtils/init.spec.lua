return function()
	local TeamUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			TeamUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(TeamUtils, {})
		end).to.throw()
	end)
end
