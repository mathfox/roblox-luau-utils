return function()
	local unequipPlayerTools = require(script.Parent)

	it("should be a function", function()
		expect(unequipPlayerTools).to.be.a("function")
	end)
end
