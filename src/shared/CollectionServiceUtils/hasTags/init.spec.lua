return function()
	local hasTags = require(script.Parent)

	it("should be a function", function()
		expect(hasTags).to.be.a("function")
	end)
end
