return function()
	local clearAllDescendantsOfClass = require(script.Parent)

	it("should be a function", function()
		expect(clearAllDescendantsOfClass).to.be.a("function")
	end)
end
