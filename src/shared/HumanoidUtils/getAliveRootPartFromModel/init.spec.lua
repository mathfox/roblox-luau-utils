return function()
	local getAliveRootPartFromModel = require(script.Parent)

	it("should be a function", function()
		expect(getAliveRootPartFromModel).to.be.a("function")
	end)
end
