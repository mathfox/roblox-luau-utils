return function()
	local Symbol = require(script.Parent)

	it("should expose a function", function()
		expect(Symbol).to.be.a("function")
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
