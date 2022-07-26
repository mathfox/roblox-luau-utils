return function()
	local Config = require(script.Parent)

	it("should expose a  table", function()
		expect(Config).to.be.a("table")
	end)

	it("should not contain the metatable", function()
		expect(getmetatable(Config)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			Config._ = {}
		end).to.throw()

		expect(function()
			setmetatable(Config, {})
		end).to.throw()
	end)
end
