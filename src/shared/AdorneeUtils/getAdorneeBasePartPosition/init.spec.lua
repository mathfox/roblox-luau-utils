return function()
	local getAdorneeBasePartPosition = require(script.Parent)

	it("should be a function", function()
		expect(getAdorneeBasePartPosition).to.be.a("function")
	end)
end
