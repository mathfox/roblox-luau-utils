return function()
	local GlobalConfig = require(script.Parent.Parent.GlobalConfig)

	local Signal = require(script.Parent)

	it("should expose a table", function()
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

	it("should fire connected callbacks", function()
		local callCount = 0
		local value1 = "Hello World"
		local value2 = 7

		local callback = function(arg1, arg2)
			expect(arg1).to.equal(value1)
			expect(arg2).to.equal(value2)
			callCount += 1
		end

		local signal = Signal.new()

		local disconnect = signal:connect(callback)
		signal:fire(value1, value2)

		expect(callCount).to.equal(1)

		disconnect()
		signal:fire(value1, value2)

		expect(callCount).to.equal(1)
	end)

	it("should disconnect handlers", function()
		local callback = function()
			error("Callback was called after disconnect!")
		end

		local signal = Signal.new()

		local disconnect = signal:connect(callback)
		disconnect()

		signal:fire()
	end)

	it("should fire handlers in order", function()
		local signal = Signal.new()
		local x = 0
		local y = 0

		local callback1 = function()
			expect(x).to.equal(0)
			expect(y).to.equal(0)
			x += 1
		end

		local callback2 = function()
			expect(x).to.equal(1)
			expect(y).to.equal(0)
			y += 1
		end

		signal:connect(callback1)
		signal:connect(callback2)
		signal:fire()

		expect(x).to.equal(1)
		expect(y).to.equal(1)
	end)

	it("should continue firing despite mid-event disconnection", function()
		local signal = Signal.new()
		local countA = 0
		local countB = 0

		local disconnect
		disconnect = signal:connect(function()
			disconnect()
			countA = countA + 1
		end)

		signal:connect(function()
			countB = countB + 1
		end)

		signal:fire()

		expect(countA).to.equal(1)
		expect(countB).to.equal(1)
	end)

	it("should skip listeners that were disconnected during event evaluation", function()
		local signal = Signal.new()
		local countA = 0
		local countB = 0

		local disconnect
		signal:connect(function()
			countA += 1
			disconnect()
		end)

		disconnect = signal:connect(function()
			countB += 1
		end)

		signal:fire()

		expect(countA).to.equal(1)
		expect(countB).to.equal(0)
	end)

	it("should throw an error if the argument to `connect` is not a function", function()
		GlobalConfig.set({
			typeChecks = true,
		})

		local signal = Signal.new()

		expect(function()
			signal:connect("not a function")
		end).to.throw()
	end)

	it("should throw an error when disconnecting more than once", function()
		local signal = Signal.new()

		local disconnect = signal:connect(function() end)

		-- Okay to disconnect once
		expect(disconnect).never.to.throw()

		-- Throw an error if we disconnect twice
		expect(disconnect).to.throw()
	end)

	it("should throw an error when subscribing during dispatch", function()
		local mockStore = {
			_isDispatching = false,
		}
		local signal = Signal.new(mockStore)

		signal:connect(function()
			-- Subscribe while listeners are being fired
			signal:connect(function() end)
		end)

		mockStore._isDispatching = true
		expect(function()
			signal:fire()
		end).to.throw()
	end)

	it("should throw an error when unsubscribing during dispatch", function()
		local mockStore = {
			_isDispatching = false,
		}
		local signal = Signal.new(mockStore)

		local connection
		connection = signal:connect(function()
			connection.disconnect()
		end)

		mockStore._isDispatching = true
		expect(function()
			signal:fire()
		end).to.throw()
	end)
end
