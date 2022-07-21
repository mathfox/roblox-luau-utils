return function()
	local teleportHumanoidToPosition = require(script.Parent)

	it("should be a function", function()
		expect(teleportHumanoidToPosition).to.be.a("function")
	end)
end
