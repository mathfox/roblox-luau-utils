return function()
	local getAdorneeAlignedSize = require(script.Parent)

	it("should should error when non-Instance value provided", function()
		expect(function()
			getAdorneeAlignedSize()
			getAdorneeAlignedSize(math.huge)
			getAdorneeAlignedSize("string")
			getAdorneeAlignedSize({})
		end).never.to.throw()
	end)
end
