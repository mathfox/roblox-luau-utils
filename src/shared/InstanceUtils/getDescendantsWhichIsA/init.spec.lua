return function()
	local getDescendantsWhichIsA = require(script.Parent)

	it("should be a function", function()
		expect(getDescendantsWhichIsA).to.be.a("function")
	end)
end
