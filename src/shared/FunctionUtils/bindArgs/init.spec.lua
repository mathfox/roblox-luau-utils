return function()
	local bindArgs = require(script.Parent)

	it("should throw an error if func argument is not a function", function()
		expect(function()
			bindArgs()
		end).to.throw()

		expect(function()
			bindArgs({})
		end).to.throw()
	end)

	it("should properly bind arguments to a function", function()
		expect(function()
			bindArgs(function(a, b, c)
				assert(a == 1, b == 2, c == 3)
			end, 1, 2, 3)(4)
		end).never.throw()
	end)
end
