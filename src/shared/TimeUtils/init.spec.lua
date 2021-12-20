return function()
	local TimeUtils = require(script.Parent)

	describe("getUnixTime", function()
		it("should return proper unix time", function()
			expect(TimeUtils.getUnixTime()).to.be.near(DateTime.now().UnixTimestamp)
		end)

		it("should never return invalid unix time", function()
			expect(TimeUtils.getUnixTime()).never.to.be.near(0)
		end)
	end)
end
