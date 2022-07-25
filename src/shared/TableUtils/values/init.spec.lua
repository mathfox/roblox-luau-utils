return function()
	local values = require(script.Parent)

	it("should be a function", function()
		expect(values).to.be.a("function")
	end)
end
