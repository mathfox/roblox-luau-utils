return function()
	local waitForDescendantWhichIsA = require(script.Parent)

	it("should be a function", function()
		expect(waitForDescendantWhichIsA).to.be.a("function")
	end)
end
