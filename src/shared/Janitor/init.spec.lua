return function()
	local Janitor = require(script.Parent)

	it("should be a table", function()
		expect(Janitor).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(Janitor)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			Janitor._ = {}
		end).to.throw()

		expect(function()
			setmetatable(Janitor, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			new = "function",
			is = "function",
		}

		expect(function()
			for key, value in Janitor do
				assert(knownAPIs[key] ~= nil)
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
