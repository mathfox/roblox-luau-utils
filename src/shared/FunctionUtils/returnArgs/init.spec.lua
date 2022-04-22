return function()
	local returnArgs = require(script.Parent)

	it("should provide proper values", function()
		expect(function()
			local a, b, c = returnArgs(1, 2, 3)()
			assert(a == 1, b == 2, c == 3)
		end).never.throw()
	end)
end
