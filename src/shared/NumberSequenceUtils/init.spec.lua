return function()
	local NumberSequenceUtils = require(script.Parent)

	it("should be a table", function()
		expect(NumberSequenceUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(NumberSequenceUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			NumberSequenceUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(NumberSequenceUtils, {})
		end).to.throw()
	end)
end
