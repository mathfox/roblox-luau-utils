return function()
	local Types = require(script.Parent)

	it("should return nil", function()
		expect(Types).to.equal(nil)
	end)
end
