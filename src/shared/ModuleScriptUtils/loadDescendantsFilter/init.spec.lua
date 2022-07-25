return function()
	local loadDescendantsFilter = require(script.Parent)

	it("should be a function", function()
		expect(loadDescendantsFilter).to.be.a("function")
	end)
end
