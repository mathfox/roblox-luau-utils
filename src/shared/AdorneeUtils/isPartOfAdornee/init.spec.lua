return function()
	local isPartOfAdornee = require(script.Parent)

	it("should be a function", function()
		expect(isPartOfAdornee).to.be.a("function")
	end)
end
