return function()
	local filterArray = require(script.Parent)

	it("should be a function", function()
		expect(filterArray).to.be.a("function")
	end)
end
