return function()
	local Enumerator = require(script.Parent)

	it("should throw an error on attempt to modify Enumerator", function()
		expect(function()
			Enumerator("a", { "a" }).NEW_FIELD = {}
		end).to.throw()

		expect(function()
			getmetatable(Enumerator("a", { "a" })).__index = {}
		end).to.throw()

		expect(function()
			setmetatable(Enumerator("a", { "a" }), {})
		end).to.throw()
	end)

	it("should construct Enumerator when valid arguments provided", function()
		return
	end)

	it("should implement __tostring metamethod", function()
		expect(function()
			local enumerator = Enumerator("a", { "a" })
			assert(tostring(enumerator) == "a")
			assert(tostring(enumerator.a) == "a.a")
		end).never.to.throw()
	end)

	describe("EnumeratorItem", function()
		it("should throw an error on attempt to modify a table", function()
			expect(function()
				Enumerator("a", { "a" }).a.NEW_FIELD = {}
			end).to.throw()

			expect(function()
				setmetatable(Enumerator("a", { "a" }).a, {})
			end).to.throw()

			expect(function()
				getmetatable(Enumerator("a", { "a" }).a).__index = {}
			end).to.throw()
		end)

		it("should implement __tostring metamethod", function()
			expect(function()
				assert(tostring(Enumerator("a", { "a" }).a) == "a.a")
			end).never.to.throw()
		end)
	end)
end
