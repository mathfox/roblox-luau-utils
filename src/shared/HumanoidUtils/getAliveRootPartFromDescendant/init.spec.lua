return function()
	local getAliveRootPartFromDescendant = require(script.Parent)

	it("should be a function", function()
		expect(getAliveRootPartFromDescendant).to.be.a("function")
	end)
end
