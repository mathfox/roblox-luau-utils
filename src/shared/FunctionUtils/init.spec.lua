return function()
	local FunctionUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			FunctionUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(FunctionUtils, {})
		end).to.throw()
	end)
end
