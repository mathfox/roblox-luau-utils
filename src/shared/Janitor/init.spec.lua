return function()
	local Janitor = require(script.Parent)

	describe("Janitor.is", function()
		it("should recognize janitor constructed from Janitor.new function", function()
			expect(function()
				assert(Janitor.is(Janitor.new()) == true)
			end).never.throw()
		end)
	end)
end
