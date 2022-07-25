return function()
	local deepFreeze = require(script.Parent)

	it("should be a function", function()
		expect(deepFreeze).to.be.a("function")
	end)
end
