return function()
	local waitForDescendantOfClass = require(script.Parent)

	it("should be a function", function()
		expect(waitForDescendantOfClass).to.be.a("function")
	end)
end
