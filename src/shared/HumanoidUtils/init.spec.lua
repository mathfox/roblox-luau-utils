return function()
	local HumanoidUtils = require(script.Parent)

	it("should be a table", function()
		expect(HumanoidUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(HumanoidUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			HumanoidUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(HumanoidUtils, {})
		end).to.throw()
	end)

	it("should expose only known apis", function()
		local knownAPIs = {
			getAliveHumanoidFromDescendant = "function",
			getAliveHumanoidFromModel = "function",
			getAliveRootPartFromDescendant = "function",
			getAliveRootPartFromModel = "function",
			healHumanoid = "function",
			scaleHumanoid = "function",
			teleportHumanoidToCFrame = "function",
			teleportHumanoidToPosition = "function",
		}

		expect(function()
			for key, value in HumanoidUtils do
				assert(knownAPIs[key] ~= nil)
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
