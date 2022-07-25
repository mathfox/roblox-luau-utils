return function()
	local map = require(script.Parent)

	it("should be a function", function()
		expect(map).to.be.a("function")
	end)
end
