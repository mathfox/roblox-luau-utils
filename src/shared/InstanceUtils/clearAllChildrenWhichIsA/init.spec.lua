return function()
	local clearAllChildrenWhichIsA = require(script.Parent)

	it("should be a function", function()
		expect(clearAllChildrenWhichIsA).to.be.a("function")
	end)
end
