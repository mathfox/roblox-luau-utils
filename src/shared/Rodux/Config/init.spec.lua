return function()
	local Config = require(script.Parent)

	it("should be table", function()
		expect(Config).to.be.a("table")
	end)

	it("should not contain the metatable", function()
		expect(function()
			Config._ = {}
		end).to.throw()

		expect(function()
			setmetatable(Config, {})
		end).to.throw()
	end)
end
