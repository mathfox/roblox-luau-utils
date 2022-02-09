return function()
	local InstanceUtils = require(script.Parent)

	local instance = Instance.new("BindableEvent")
	local instanceAmount = 10
	local className = "BindableEvent"
	for _ = 1, instanceAmount do
		Instance.new(className, instance)
	end

	describe("getInstanceMass", function()
		local getInstanceMass = InstanceUtils.getInstanceMass

		local basePart = Instance.new("Part")

		it("shoud return valid base part mass", function()
			expect(getInstanceMass(basePart)).to.be.equal(basePart:GetMass())
		end)
	end)
end
