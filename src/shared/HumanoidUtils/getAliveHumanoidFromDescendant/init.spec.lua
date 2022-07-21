return function()
	local getAliveHumanoidFromDescendant = require(script.Parent)

	it("should be a function", function()
		expect(getAliveHumanoidFromDescendant).to.be.a("function")
	end)
end
