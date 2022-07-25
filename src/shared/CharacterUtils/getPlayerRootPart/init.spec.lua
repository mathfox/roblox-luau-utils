return function()
	local getPlayerRootPart = require(script.Parent)

	it("should be a function", function()
		expect(getPlayerRootPart).to.be.a("function")
	end)
end
