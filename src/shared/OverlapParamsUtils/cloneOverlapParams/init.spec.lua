return function()
	local cloneOverlapParams = require(script.Parent)

	it("should be a function", function()
		expect(cloneOverlapParams).to.be.a("function")
	end)
end
