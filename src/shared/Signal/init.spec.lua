return function()
	local void = require(script.Parent.Parent.FunctionUtils.void)

	local Signal = require(script.Parent)

	it("should be a table", function(n)
		expect(Signal).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(Signal)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			Signal._ = {}
		end).to.throw()

		expect(function()
			setmetatable(Signal, {})
		end).to.throw()
	end)

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

	describe(":once()", function()
		it("should disconnect the connection before invoking the callback", function()
			expect(function()
				local resolveAwaitThread = coroutine.running()
				local signal = Signal.new()
				local connection = nil

				connection = signal:once(function()
					task.spawn(resolveAwaitThread)
				end)

				task.defer(function()
					signal:fire()
				end)

				coroutine.yield()

				assert(not connection.connected)
			end).never.throw()
		end)
	end)
end
