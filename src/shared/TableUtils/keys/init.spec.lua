return function()
	local keys = require(script.Parent)

	it("should be a function", function()
		expect(keys).to.be.a("function")
	end)
end
