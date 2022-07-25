return function()
	local loadChildren = require(script.Parent)

	it("should be a function", function()
		expect(loadChildren).to.be.a("function")
	end)
end
