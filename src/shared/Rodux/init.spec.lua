return function()
	local Rodux = require(script.Parent)

	it("should be a table", function()
		expect(Rodux).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(Rodux)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			Rodux._ = {}
		end).to.throw()

		expect(function()
			setmetatable(Rodux, {})
		end).to.throw()
	end)
end
