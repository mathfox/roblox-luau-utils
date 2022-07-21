return function()
	local some = require(script.Parent)

	it("should be a function", function()
		expect(some).to.be.a("function")
	end)
end
