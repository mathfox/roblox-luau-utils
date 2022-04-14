return function()
	local assign = require(script.Parent)

	it("should support arrays", function()
		expect(function()
			local array1 = { 1, 2, 3, 4, 5 }
			local array2 = { 2, 4, 6, 8, 10 }

			local array3 = assign(array1, array2)
			assert(array3[1] == array2[1])

			local array4 = assign(array2, array1)
			assert(array4[1] == array1[1])

			assert(assign(array3, array4)[1] == array4[1])
		end).never.to.throw()
	end)

	it("should keep values from the latest table", function()
		expect(function()
			assert(assign({ 1 }, { 2 }, { 3 })[1] == 3)
		end).never.to.throw()
	end)
end
