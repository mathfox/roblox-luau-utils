return function()
	local Option = require(script.Parent)

	it("should be a table", function()
		expect(Option).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(Option)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			Option._ = {}
		end).to.throw()

		expect(function()
			setmetatable(Option, {})
		end).to.throw()
	end)
end
