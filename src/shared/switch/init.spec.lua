return function()
	local switch = require(script.Parent)

	it("should return the correct value", function()
		expect(switch("none", {
			none = "expected",
			_ = "unexpected",
		})).to.be.equal("expected")

		expect(switch(false, {
			[false] = "expected",
			_ = "unexpected",
		})).to.be.equal("expected")

		expect(switch(nil, {
			_ = "expected",
		})).to.be.equal("expected")
	end)

	it("should return function result", function()
		expect(switch(nil, {
			_ = function()
				return "expected"
			end,
		})).to.be.equal("expected")

		expect(switch(false, {
			[false] = function()
				return "expected"
			end,
			_ = "unexpected",
		})).to.be.equal("expected")
	end)
end
