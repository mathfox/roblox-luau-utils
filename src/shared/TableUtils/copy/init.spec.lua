return function()
	local copy = require(script.Parent)

	it("should be a function", function()
		expect(copy).to.be.a("function")
	end)

	it("should properly copy the arrays", function()
		expect(function()
			local array = { 1, 2, 3, 4, 5 }
			local copied = copy(array)

			assert(type(copied) == "table")
			assert(copied ~= array)
			assert(#copied == #array)
		end).never.throw()
	end)
end
