return function()
	local AdorneeUtils = require(script.Parent)

	it("should be a table", function()
		expect(AdorneeUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(AdorneeUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			AdorneeUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(AdorneeUtils, {})
		end).to.throw()
	end)
end
