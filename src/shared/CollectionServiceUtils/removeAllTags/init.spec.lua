return function()
	local removeAllTags = require(script.Parent)

	it("should be a function", function()
		expect(removeAllTags).to.be.a("function")
	end)
end
