return function()
	local every = require(script.Parent)

	it("should be a function", function()
		expect(every).to.be.a("function")
	end)
end
