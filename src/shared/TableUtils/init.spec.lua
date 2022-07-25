return function()
	local TableUtils = require(script.Parent)

	it("should be a table", function()
		expect(TableUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(TableUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			TableUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(TableUtils, {})
		end).to.throw()
	end)

	it("should expose known APIs", function()
		local knownAPIs = {
			assign = "function",
			copy = "function",
			deepFreeze = "function",
			deepSafeFreeze = "function",
			every = "function",
			extend = "function",
			filter = "function",
			filterArray = "function",
			find = "function",
			join = "function",
			joinArray = "function",
			keys = "function",
			length = "function",
			map = "function",
			random = "function",
			reverse = "function",
			safeFreeze = "function",
			shuffle = "function",
			some = "function",
			values = "function",
		}

		expect(function()
			for key, value in TableUtils do
				assert(knownAPIs[key] ~= nil)
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
