return function()
	local findFirstDescendantWhichIsA = require(script.Parent)

	it("should be a function", function()
		expect(findFirstDescendantWhichIsA).to.be.a("function")
	end)
end
