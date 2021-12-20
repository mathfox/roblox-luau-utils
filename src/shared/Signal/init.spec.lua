return function()
	local Signal = require(script.Parent)

	describe("is", function()
		local is = Signal.is

		it("should recognize only true Signal object", function()
			expect(is(Signal.new())).to.be.equal(true)
			expect(is({
				ClassName = "Signal",
			})).to.be.equal(false)
			expect(is(math.huge)).to.be.equal(false)
			expect(is("string")).to.be.equal(false)
			expect(is(Instance.new("BindableFunction"))).to.be.equal(false)
		end)

		it("should not error when non-table value provided", function()
			expect(function()
				is(math.huge)
			end).never.to.throw()
			expect(function()
				is("string")
			end).never.to.throw()
			expect(function()
				is(Instance.new("BindableFunction"))
			end).never.to.throw()
		end)
	end)

	describe("new", function()
		local new = Signal.new

		it("should return a new valid signal", function()
			expect(Signal.is(new())).to.be.equal(true)
		end)
	end)
end
