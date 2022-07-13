return function()
	local AdorneeUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			AdorneeUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(AdorneeUtils, {})
		end).to.throw()
	end)
end
