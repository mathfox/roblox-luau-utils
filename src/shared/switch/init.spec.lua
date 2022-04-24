return function()
	local Switch = require(script.Parent)

	it("should return the correct value", function()
		expect(Switch("none", {
			none = "expected",
			default = "unexpected",
		})).to.be.equal("expected")

		expect(Switch(false, {
			[false] = "expected",
			default = "unexpected",
		})).to.be.equal("expected")

		expect(Switch(nil, {
			default = "expected",
		})).to.be.equal("expected")
	end)

	it("should return function result", function()
		expect(Switch(nil, {
			default = function()
				return "expected"
			end,
		})).to.be.equal("expected")

		expect(Switch(false, {
			[false] = function()
				return "expected"
			end,
			default = "unexpected",
		})).to.be.equal("expected")
	end)

	it("should error when wront input provided", function()
		expect(function()
			Switch()
		end).to.throw()
	end)
end
