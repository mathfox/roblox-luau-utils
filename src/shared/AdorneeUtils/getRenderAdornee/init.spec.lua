return function()
	local getRenderAdornee = require(script.Parent)

	it("should be a function", function()
		expect(getRenderAdornee).to.be.a("function")
	end)
end
