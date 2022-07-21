return function()
	local random = require(script.Parent)

	it("should be a function", function()
		expect(random).to.be.a("function")
	end)
end
