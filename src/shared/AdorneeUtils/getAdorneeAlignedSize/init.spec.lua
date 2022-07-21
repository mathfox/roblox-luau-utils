return function()
	local getAdorneeAlignedSize = require(script.Parent)

	it("should be a function", function()
		expect(getAdorneeAlignedSize).to.be.a("function")
	end)
end
