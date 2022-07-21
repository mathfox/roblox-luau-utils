return function()
	local waitUntilParentedTo = require(script.Parent)

	it("should be a function", function()
		expect(waitUntilParentedTo).to.be.a("function")
	end)
end
