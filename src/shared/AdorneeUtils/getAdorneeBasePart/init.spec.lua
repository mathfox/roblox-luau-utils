return function()
	local getAdorneeBasePart = require(script.Parent)

	it("should be a function", function()
		expect(getAdorneeBasePart).to.be.a("function")
	end)

	it("should return the BasePart itself in case it is provided", function()
		local part = Instance.new("Part")

		expect(getAdorneeBasePart(part)).to.equal(part)

		part:Destroy()
	end)
end
