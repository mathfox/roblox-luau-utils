return function()
	local getRandomFloat = require(script.Parent)

	it("should be a function", function()
		expect(getRandomFloat).to.be.a("function")
	end)
end
