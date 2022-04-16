return function()
	local Result = require(script.Parent)

	it("should throw an error to modify the exported table", function()
		expect(function()
			Result.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(Result, {})
		end)
	end)

	it("should thrown an error on attempt to modify the metatable of Ok", function()
		expect(function()
			getmetatable(Result.Ok(0)).__index = {}
		end).to.throw()
	end)

	it("should throw an error on attempt to modify the metatable of Ok", function()
		expect(function()
			getmetatable(Result.Err(0)).__index = {}
		end).to.throw()
	end)

	it("should throw an error on attempt to modify the Result object", function()
		expect(function()
			Result.Ok(0).NEW_FIELD = {}
		end).to.throw()

		expect(function()
			Result.Err(0).NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(Result.Ok(0), {})
		end).to.throw()

		expect(function()
			setmetatable(Result.Err(0), {})
		end).to.throw()

		expect(function()
			Result.Ok(0):map(function(num)
				return num + 1
			end).NEW_FIELD = {}
		end).to.throw()

		expect(function()
			Result.Err(0):mapErr(function(num)
				return num + 1
			end).NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(
				Result.Ok(0):map(function(num)
					return num + 1
				end),
				{}
			)
		end).to.throw()

		expect(function()
			setmetatable(
				Result.Err(0):mapErr(function(num)
					return num + 1
				end),
				{}
			)
		end)
	end)

	describe(":isOkWith()", function()
		it("should throw an error if returned value is not a boolean", function()
			expect(function()
				Result.Ok(0):isOkWith(function() end)
			end).to.throw()
		end)
	end)
end
