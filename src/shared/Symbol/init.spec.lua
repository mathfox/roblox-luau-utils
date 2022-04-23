return function()
	local Symbol = require(script.Parent)

	it("should throw an error on attempt to modify export table", function()
		expect(function()
			Symbol.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(Symbol, {})
		end).to.throw()
	end)

	describe("named", function()
		it("should throw an error if name argument is an empty string", function()
			expect(function()
				Symbol.named("")
			end).to.throw()
		end)

		it("should throw if extra arguments provided", function()
			expect(function()
				Symbol.named("foo", nil)
			end).to.throw()

			expect(function()
				Symbol.named("foo", {})
			end).to.throw()

			expect(function()
				Symbol.named("foo", nil, nil, {})
			end).to.throw()
		end)

		it("should give an opaque object", function()
			local symbol = Symbol.named("foo")

			expect(symbol).to.be.a("userdata")
		end)

		it("should coerce to the given name", function()
			local symbol = Symbol.named("foo")

			expect(tostring(symbol):find("foo")).to.be.ok()
		end)

		it("should be unique when constructed", function()
			local symbolA = Symbol.named("abc")
			local symbolB = Symbol.named("abc")

			expect(symbolA).never.to.equal(symbolB)
		end)
	end)

	describe("unnamed", function()
		it("should throw an error if any argument provided", function()
			expect(function()
				Symbol.unnamed(nil)
			end).to.throw()

			expect(function()
				Symbol.unnamed({})
			end).to.throw()

			expect(function()
				Symbol.unnamed(nil, {})
			end).to.throw()
		end)
	end)
end
