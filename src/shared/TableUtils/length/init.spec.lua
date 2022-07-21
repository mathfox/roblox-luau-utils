return function()
	local length = require(script.Parent)

	it("should be a function", function()
		expect(length).to.be.a("function")
	end)
end
