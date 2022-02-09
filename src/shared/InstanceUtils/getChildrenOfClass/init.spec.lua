return function()
	local getChildrenOfClass = require(script.Parent)

	local instance = Instance.new("BindableEvent")
	local bindableFunction = Instance.new("BindableFunction", instance)

	afterAll(function()
		instance:Destroy()
	end)

	it("should return valid children amount", function()
		expect(function()
			assert(getChildrenOfClass(instance, bindableFunction.ClassName) == bindableFunction)
			assert(getChildrenOfClass(instance, instance.ClassName) == nil)
		end).never.to.throw()
	end)
end
