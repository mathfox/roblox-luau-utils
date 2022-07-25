return function()
	local ModelUtils = require(script.Parent)

	it("should be a table", function()
		expect(ModelUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(ModelUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			ModelUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(ModelUtils, {})
		end).to.throw()
	end)
end
