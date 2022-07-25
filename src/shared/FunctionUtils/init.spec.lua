return function()
	local FunctionUtils = require(script.Parent)

	it("should be a table", function()
		expect(FunctionUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(FunctionUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			FunctionUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(FunctionUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			bindArgs = "function",
			noop = "function",
			returnArgs = "function",
			void = "function",
		}

		expect(function()
			for key, value in FunctionUtils do
				assert(knownAPIs[key] ~= nil)
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
