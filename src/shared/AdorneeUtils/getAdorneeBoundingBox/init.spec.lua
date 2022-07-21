return function()
	local getAdorneeBoundingBox = require(script.Parent)

	it("should be a function", function()
		expect(getAdorneeBoundingBox).to.be.a("function")
	end)
end
