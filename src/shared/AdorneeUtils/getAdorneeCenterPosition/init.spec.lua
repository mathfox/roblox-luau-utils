return function()
	local getAdorneeCenterPosition = require(script.Parent)

	it("should be a function", function()
		expect(getAdorneeCenterPosition).to.be.a("function")
	end)
end
