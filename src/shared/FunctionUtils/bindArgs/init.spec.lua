return function()
	local bindArgs = require(script.Parent)

	it("should be a function", function()
		expect(bindArgs).to.be.a("function")
	end)

	it("should pass the provided arguments first", function()
		expect(function()
			bindArgs(function(a, b, c)
				assert(a == 1, b == 2, c == 3)
			end, 1, 2, 3)(4, 5, 6)
		end).never.throw()
	end)
end
