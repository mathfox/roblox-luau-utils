return function()
	local shuffle = require(script.Parent)

	it("should be a function", function()
		expect(shuffle).to.be.a("function")
	end)
end
