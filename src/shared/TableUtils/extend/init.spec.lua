return function()
	local extend = require(script.Parent)

	it("should be a function", function()
		expect(extend).to.be.a("function")
	end)
end
