return function()
	local loadDescendants = require(script.Parent)

	it("should be a function", function()
		expect(loadDescendants).to.be.a("function")
	end)
end
