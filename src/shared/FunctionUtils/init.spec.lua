return function()
	local FunctionUtils = require(script.Parent)

	it("should be a table", function()
		expect(FunctionUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(FunctionUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			FunctionUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(FunctionUtils, {})
		end).to.throw()
	end)
end
