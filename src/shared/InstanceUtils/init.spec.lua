return function()
	local InstanceUtils = require(script.Parent)

	local instance = Instance.new("BindableEvent")
	local instanceAmount = 10
	local className = "BindableEvent"
	for _ = 1, instanceAmount do
		Instance.new(className, instance)
	end

	describe("getChildrenOfClass", function()
		local getChildrenOfClass = InstanceUtils.getChildrenOfClass

		it("should return valid children amount", function()
			expect(#getChildrenOfClass(instance, className)).to.be.equal(instanceAmount)
		end)

		it("should error on invalid input", function()
			expect(function()
				getChildrenOfClass()
			end).to.throw()
		end)
	end)

	describe("getDescendantsOfClass", function()
		local getDescendantsOfClass = InstanceUtils.getDescendantsOfClass

		it("should return valid descendants amount", function()
			expect(#getDescendantsOfClass(instance, className)).to.be.equal(instanceAmount)
		end)

		it("should error on invalid input", function()
			expect(function()
				getDescendantsOfClass()
			end).to.throw()
		end)
	end)

	describe("waitForChildOfClass", function()
		local waitForChildOfClass = InstanceUtils.waitForChildOfClass

		it("should return valid child of class", function()
			expect(waitForChildOfClass(instance, className).ClassName).to.be.equal(className)
		end)

		it("should error when invalid input provided", function()
			expect(function()
				waitForChildOfClass()
			end).to.throw()
		end)
	end)

	describe("waitForDescendantOfClass", function()
		local waitForDescendantOfClass = InstanceUtils.waitForDescendantOfClass

		it("should return valid descendant of class", function()
			expect(waitForDescendantOfClass(instance, className).ClassName).to.be.equal(className)
		end)

		it("should error when invalid input provided", function()
			expect(function()
				waitForDescendantOfClass()
			end).to.throw()
		end)
	end)

	describe("getInstanceMass", function()
		local getInstanceMass = InstanceUtils.getInstanceMass

		local basePart = Instance.new("Part")

		it("shoud return valid base part mass", function()
			expect(getInstanceMass(basePart)).to.be.equal(basePart:GetMass())
		end)
	end)
end
