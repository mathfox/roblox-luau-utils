return function()
	local getRandomInt = require(script.Parent)

	it("should be a function", function()
		expect(getRandomInt).to.be.a("function")
	end)
end
