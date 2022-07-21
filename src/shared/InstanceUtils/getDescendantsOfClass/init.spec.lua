return function()
	local getDescendantsOfClass = require(script.Parent)

	it("should be a function", function()
		expect(getDescendantsOfClass).to.be.a("function")
	end)
end
