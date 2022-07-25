return function()
	local waitForChildWhichIsA = require(script.Parent)

	it("should be a function", function()
		expect(waitForChildWhichIsA).to.be.a("function")
	end)
end
