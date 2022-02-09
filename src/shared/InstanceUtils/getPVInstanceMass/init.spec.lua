return function()
	local getPVInstanceMass = require(script.Parent)

	local basePart = Instance.new("Part")

	it("shoud return valid base part mass", function()
		expect(getPVInstanceMass(basePart)).to.be.equal(basePart:GetMass())
	end)
end
