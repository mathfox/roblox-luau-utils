return function()
	local reverse = require(script.Parent)

	it("should be a function", function()
		expect(reverse).to.be.a("function")
	end)
end
