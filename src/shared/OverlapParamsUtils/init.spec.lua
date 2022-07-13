return function()
	local OverlapParamsUtils = require(script.Parent)

	it("should be a table", function()
		expect(OverlapParamsUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(OverlapParamsUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			OverlapParamsUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(OverlapParamsUtils, {})
		end).to.throw()
	end)
end
