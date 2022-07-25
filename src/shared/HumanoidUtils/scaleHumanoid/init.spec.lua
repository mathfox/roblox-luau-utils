return function()
	local scaleHumanoid = require(script.Parent)

	it("should be a function", function()
		expect(scaleHumanoid).to.be.a("function")
	end)
end
