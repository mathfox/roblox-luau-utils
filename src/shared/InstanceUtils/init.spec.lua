return function()
	local InstanceUtils = require(script.Parent)

	it("should be a table", function()
		expect(InstanceUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(InstanceUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			InstanceUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(InstanceUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			clearAllChildrenOfClass = "function",
			clearAllChildrenWhichIsA = "function",
			clearAllDescendantsOfClass = "function",
			clearAllDescendantsWhichIsA = "function",
			findFirstDescendantOfClass = "function",
			findFirstDescendantWhichIsA = "function",
			getChildrenOfClass = "function",
			getChildrenWhichIsA = "function",
			getDescendantsOfClass = "function",
			getDescendantsWhichIsA = "function",
			waitForChildOfClass = "function",
			waitForChildWhichIsA = "function",
			waitForDescendantOfClass = "function",
			waitForDescendantWhichIsA = "function",
			waitUntilParentedTo = "function",
		}

		expect(function()
			for key, value in InstanceUtils do
				assert(knownAPIs[key] ~= nil and type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
