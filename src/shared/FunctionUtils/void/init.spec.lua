return function()
	local void = require(script.Parent)

	it("should return no values", function()
		expect(function()
			assert(select("#", void()) == 0)
		end).never.throw()
	end)
end
