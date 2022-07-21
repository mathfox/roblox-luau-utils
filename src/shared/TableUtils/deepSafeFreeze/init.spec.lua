return function()
	local deepSafeFreeze = require(script.Parent)

	it("should be a function", function()
		expect(deepSafeFreeze).to.be.a("function")
	end)
end
