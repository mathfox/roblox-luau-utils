return function()
	local findFirstDescendantOfClass = require(script.Parent)

	it("should be a function", function()
		expect(findFirstDescendantOfClass).to.be.a("function")
	end)
end
