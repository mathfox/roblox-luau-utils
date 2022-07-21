return function()
	local cloneRaycastParams = require(script.Parent)

	it("should be a function", function()
		expect(cloneRaycastParams).to.be.a("function")
	end)
end
