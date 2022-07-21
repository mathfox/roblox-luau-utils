return function()
	local teleportHumanoidToCFrame = require(script.Parent)

	it("should be a function", function()
		expect(teleportHumanoidToCFrame).to.be.a("function")
	end)
end
