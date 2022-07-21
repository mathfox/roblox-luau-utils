return function()
	local joinArray = require(script.Parent)

	it("should be a function", function()
		expect(joinArray).to.be.a("function")
	end)
end
