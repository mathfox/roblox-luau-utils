return function()
	local getAliveHumanoidFromModel = require(script.Parent)

	it("should be a function", function()
		expect(getAliveHumanoidFromModel).to.be.a("function")
	end)
end
