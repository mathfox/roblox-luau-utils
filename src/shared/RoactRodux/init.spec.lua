return function()
	local RoactRodux = require(script.Parent)

	it("should be a table", function()
		expect(RoactRodux).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(RoactRodux)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			RoactRodux._ = {}
		end).to.throw()

		expect(function()
			setmetatable(RoactRodux, {})
		end).to.throw()
	end)
end
