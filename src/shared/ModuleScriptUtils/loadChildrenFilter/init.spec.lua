return function()
	local loadChildrenFilter = require(script.Parent)

	it("should be a function", function()
		expect(loadChildrenFilter).to.be.a("function")
	end)
end
