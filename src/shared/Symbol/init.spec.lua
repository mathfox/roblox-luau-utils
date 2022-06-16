return function()
	local Symbol = require(script.Parent)

	it("should throw an error on attempt to modify export table", function()
		expect(function()
			Symbol.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(Symbol, {})
		end).to.throw()

		expect(function()
			getmetatable(Symbol).__index = {}
		end).to.throw()
	end)

	it("should implement __call metamethod", function()
		expect(function()
			Symbol()
			Symbol("foo")
		end).never.throw()
	end)

	it("should give an opaque object", function()
		expect(Symbol("foo")).to.be.a("table")
	end)

	it("should coerce to the given name", function()
		expect(tostring(Symbol("foo")):find("foo")).to.be.ok()
	end)

	it("should be unique when constructed", function()
		local symbolA = Symbol("abc")
		local symbolB = Symbol("abc")

		expect(symbolA).never.to.equal(symbolB)
	end)
end
