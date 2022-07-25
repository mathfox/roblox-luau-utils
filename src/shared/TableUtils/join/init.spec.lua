return function()
	local join = require(script.Parent)

	it("should be a function", function()
		expect(join).to.be.a("function")
	end)
end
