return function()
	local filter = require(script.Parent)

	it("should be a function", function()
		expect(filter).to.be.a("function")
	end)
end
