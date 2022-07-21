return function()
	local InstanceUtils = require(script.Parent)

	it("should be a table", function()
		expect(InstanceUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(InstanceUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			InstanceUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(InstanceUtils, {})
		end).to.throw()
	end)
end
