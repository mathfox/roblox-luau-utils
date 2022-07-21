return function()
	local clearAllChildrenOfClass = require(script.Parent)

	it("should be a function", function()
		expect(clearAllChildrenOfClass).to.be.a("function")
	end)
end
