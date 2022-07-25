return function()
	local noop = require(script.Parent)

	it("should be a function", function()
		expect(noop).to.be.a("function")
	end)

	it("should return nil when called", function()
		local amount = select("#", noop())
		expect(amount).to.equal(1)
		expect(noop()).to.equal(nil)
	end)
end
