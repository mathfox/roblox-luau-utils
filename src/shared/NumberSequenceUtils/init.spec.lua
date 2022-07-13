return function()
	local NumberSequenceUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			NumberSequenceUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(NumberSequenceUtils, {})
		end).to.throw()
	end)
end
