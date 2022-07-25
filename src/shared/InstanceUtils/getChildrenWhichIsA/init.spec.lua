return function()
	local getChildrenWhichIsA = require(script.Parent)

	it("should be a function", function()
		expect(getChildrenWhichIsA).to.be.a("function")
	end)
end
