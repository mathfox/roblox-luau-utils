return function()
	local safeFreeze = require(script.Parent)

	it("should be a function", function()
		expect(safeFreeze).to.be.a("function")
	end)
end
