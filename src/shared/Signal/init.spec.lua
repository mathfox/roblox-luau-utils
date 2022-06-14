return function()
	local void = require(script.Parent.Parent.FunctionUtils.void)
	local Signal = require(script.Parent)

	it("should support restricted behaviour", function()
		expect(function()
			local RestrictedSignal = {}

			function RestrictedSignal:__index(index)
				if index == "connect" or index == "wait" then
					return Signal.prototype[index]
				end
			end

			function RestrictedSignal.new()
				return setmetatable({}, RestrictedSignal)
			end

			local newSignal = RestrictedSignal.new()

			assert(not pcall(function()
				newSignal:fire()
			end))

			assert(not pcall(function()
				newSignal:destroy()
			end))

			task.defer(function()
				Signal.prototype.fire(newSignal, "foo")
			end)

			newSignal:connect(function(value)
				assert(value == "foo")
			end)

			assert(newSignal:wait() == "foo")
		end).never.throw()
	end)
end
