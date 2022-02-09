return function()
	local waitForDescendantOfClass = require(script.Parent)

	local instance = Instance.new("BindableEvent")
	local bindableFunction = Instance.new("BindableFunction", instance)
	local bindableEvent = Instance.new("BindableEvent", bindableFunction)

	afterAll(function()
		instance:Destroy()
	end)

	it("should return a valid descendant of class", function()
		expect(function()
			assert(waitForDescendantOfClass(instance, bindableEvent.ClassName) == bindableEvent)
			assert(waitForDescendantOfClass(instance, bindableEvent.ClassName, 0) == bindableEvent)
			assert(waitForDescendantOfClass(instance, bindableEvent.ClassName, math.huge) == bindableEvent)
		end).never.to.throw()
	end)
end
