return function()
	local ModuleScriptUtils = require(script.Parent)

	it("should be a table", function()
		expect(ModuleScriptUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function(n)
		expect(getmetatable(ModuleScriptUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			ModuleScriptUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(ModuleScriptUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			loadChildren = "function",
			loadChildrenFilter = "function",
			loadDescendants = "function",
			loadDescendantsFilter = "function",
		}

		expect(function()
			for key, value in ModuleScriptUtils do
				assert(knownAPIs[key] ~= nil and type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
