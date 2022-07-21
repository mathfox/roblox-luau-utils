return function()
	local waitForChildOfClass = require(script.Parent)

	it("should be a function", function()
		expect(waitForChildOfClass).to.be.a("function")
	end)
end
