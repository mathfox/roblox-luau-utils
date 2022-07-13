return function()
	local makeActionCreator = require(script.Parent)

	it("should be a function", function()
		expect(makeActionCreator).to.be.a("function")
	end)

	it("should set the name of the actionCreator creator", function()
		local FooAction = makeActionCreator("foo", function()
			return {}
		end)

		expect(FooAction.name).to.equal("foo")
	end)

	it("should return a table when called as a function", function()
		local FooAction = makeActionCreator("foo", function()
			return {}
		end)

		expect(FooAction()).to.be.a("table")
	end)

	it("should set the type of the action creator", function()
		local FooAction = makeActionCreator("foo", function()
			return {}
		end)

		expect(FooAction().type).to.equal("foo")
	end)

	it("should set values", function()
		local FooAction = makeActionCreator("foo", function(value)
			return {
				value = value,
			}
		end)

		expect(FooAction(100).value).to.equal(100)
	end)

	it("should throw when its result does not return a table", function()
		local FooAction = makeActionCreator("foo", function()
			return function() end
		end)

		expect(FooAction).to.throw()
	end)
end
