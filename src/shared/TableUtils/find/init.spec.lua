return function()
	local find = require(script.Parent)

	it("should be a function", function()
		expect(find).to.be.a("function")
	end)
end
