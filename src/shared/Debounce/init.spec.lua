return function()
	local Debounce = require(script.Parent)
	local randomMessage = "random_debounce_message"

	describe("once", function()
		it("should support only successFunction provided", function()
			expect(Debounce.once(function(message)
				return message == randomMessage
			end).OnInvoke(randomMessage)).to.be.equal(true)
		end)

		it("should error when no successFunction passed", function()
			expect(function()
				Debounce.once()
			end).to.throw()
		end)

		it("should support both successFunction and failFunction provided", function()
			local debounce = Debounce.once(function(successMessage)
				return successMessage == randomMessage
			end, function(...)
				return ...
			end)

			expect(debounce.OnInvoke(randomMessage)).to.be.equal(true)
			expect(debounce.OnInvoke(math.huge)).to.be.equal(math.huge)
		end)
	end)
end
