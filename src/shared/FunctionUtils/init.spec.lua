return function()
	local FunctionUtils = require(script.Parent)

	it("should throw an error on attempt to modify an export table", function()
		expect(function()
			FunctionUtils.NEW_FIELD = {}
		end).to.throw()
	end)
end
