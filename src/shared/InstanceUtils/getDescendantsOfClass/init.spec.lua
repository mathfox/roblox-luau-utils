return function()
	local getDescendantsOfClass = require(script.Parent)

	local bindableEventsAmount = 10
	local bindableFunctionsAmount = 10
	local instance = Instance.new("BindableEvent")

	for _ = 1, bindableEventsAmount do
		Instance.new("BindableEvent", instance)
	end

	for _ = 1, bindableFunctionsAmount do
		Instance.new("BindableFunction", instance)
	end

	afterAll(function()
		instance:Destroy()
	end)

	it("should return a valid descendants of class", function()
		expect(function()
			assert(#getDescendantsOfClass(instance, "BindableEvent") == bindableEventsAmount)
			assert(#getDescendantsOfClass(instance, "BindableFunction") == bindableFunctionsAmount)
			assert(#getDescendantsOfClass(instance, "Model") == 0)
		end).never.to.throw()
	end)
end
