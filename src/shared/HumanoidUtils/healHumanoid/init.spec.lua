return function()
	local healHumanoid = require(script.Parent)

	it("should be a function", function()
		expect(healHumanoid).to.be.a("function")
	end)
end
