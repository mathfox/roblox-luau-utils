return function()
	local getChildrenOfClass = require(script.Parent)

	it("should be a function", function()
		expect(getChildrenOfClass).to.be.a("function")
	end)
end
