return function()
	local Maid = require(script.Parent)

	describe("new", function()
		local new = Maid.new

		it("should create a valid Maid", function()
			expect(Maid.is(new())).to.be.equal(true)
		end)
	end)
end
