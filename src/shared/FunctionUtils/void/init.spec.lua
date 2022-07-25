return function()
	local void = require(script.Parent)

	it("should be a function", function()
		expect(void).to.be.a("function")
	end)

	it("should return no arguments when called", function()
		expect(select("#", void())).to.equal(0)
	end)
end
