return function()
	local switch = require(script.Parent)

	it("should return the correct value", function()
		expect(switch("none", {
			none = "expected",
			default = "unexpected",
		})).to.be.equal("expected")

		expect(switch(false, {
			[false] = "expected",
			default = "unexpected",
		})).to.be.equal("expected")

		expect(switch(nil, {
			default = "expected",
		})).to.be.equal("expected")
	end)

	it("should return function result", function()
		expect(switch(nil, {
			default = function()
				return "expected"
			end,
		})).to.be.equal("expected")

		expect(switch(false, {
			[false] = function()
				return "expected"
			end,
			default = "unexpected",
		})).to.be.equal("expected")
	end)

	it("should error when wront input provided", function()
		expect(function()
			switch()
		end).to.throw()
	end)
end
