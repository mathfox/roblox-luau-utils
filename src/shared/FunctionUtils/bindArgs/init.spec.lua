return function()
	local bindArgs = require(script.Parent)

	it("should properly bind arguments to a function", function()
		expect(function()
			bindArgs(function(a, b, c)
				assert(a == 1, b == 2, c == 3)
			end, 1, 2, 3)(4)
		end).never.throw()
	end)
end
