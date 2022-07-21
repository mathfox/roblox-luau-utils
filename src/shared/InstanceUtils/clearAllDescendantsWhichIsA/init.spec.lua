return function()
	local clearAllDescendantsWhichIsA = require(script.Parent)

	it("should be a function", function()
		expect(clearAllDescendantsWhichIsA).to.be.a("function")
	end)
end
