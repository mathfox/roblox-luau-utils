return function()
	local Queue = require(script.Parent)

	describe("new", function()
		local new = Queue.new

		it("should support varangs queue", function()
			local queue = new()

			queue:enqueue("index1", "value1", {
				index1 = "value1",
			})

			queue:enqueue("index2", "value2", {
				index2 = "value2",
			})

			local index1, value1, tbl1 = queue:dequeue()
			expect(index1).to.be.equal("index1")
			expect(value1).to.be.equal("value1")
			expect(tbl1.index1).to.be.equal("value1")

			local index2, value2, tbl2 = queue:dequeue()
			expect(index2).to.be.equal("index2")
			expect(value2).to.be.equal("value2")
			expect(tbl2.index2).to.be.equal("value2")
		end)
	end)

	describe("is", function()
		local is = Queue.is
	end)
end
