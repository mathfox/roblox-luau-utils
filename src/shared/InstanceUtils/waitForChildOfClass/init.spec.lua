return function()
	local waitForChildOfClass = require(script.Parent)

	local bindableEvent = Instance.new("BindableEvent")
	local bindableFunction = Instance.new("BindableFunction", bindableEvent)

	afterAll(function()
		bindableEvent:Destroy()
	end)

	it("should return a valid child of class", function()
		expect(function()
			assert(waitForChildOfClass(bindableFunction, bindableEvent.ClassName) == bindableEvent)
			assert(waitForChildOfClass(bindableFunction, bindableEvent.ClassName, 0) == bindableEvent)
			assert(waitForChildOfClass(bindableFunction, bindableEvent.ClassName, math.huge) == bindableEvent)
		end).never.to.throw()
	end)
end
