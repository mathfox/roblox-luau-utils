return function()
	local returnArgs = require(script.Parent)

	it("should be a function", function()
		expect(returnArgs).to.be.a("function")
	end)

	it("should return provided arguments", function()
		assert(returnArgs(true)() == true)

		local a, b, c = 1, 2, 3
		local values = { returnArgs(a, b, c)() }
		assert(values[1] == a, values[2] == b, values[3] == c)
	end)
end
