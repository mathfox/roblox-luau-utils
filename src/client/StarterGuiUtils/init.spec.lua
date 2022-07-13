return function()
	local StarterGuiUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			StarterGuiUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(StarterGuiUtils, {})
		end).to.throw()
	end)
end
