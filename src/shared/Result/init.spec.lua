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

	describe("Ok", function()
		it("should print a nice string instead of a table", function()
			expect(function()
				assert(tostring(Result.Ok()) == "Ok<nil>")
				assert(tostring(Result.Ok(1)) == "Ok<number>")
				assert(tostring(Result.Ok(CFrame.identity)) == "Ok<CFrame>")
			end).never.to.throw()
		end)

		it("should implement __eq metamethod", function()
			expect(function()
				assert(Result.Ok() == Result.Ok())
				assert(Result.Ok(0) == Result.Ok(0))
			end).never.to.throw()
		end)
	end)

	describe("Err", function()
		it("should print a nice string instead of a table", function()
			expect(function()
				assert(tostring(Result.Err()) == "Err<nil>")
				assert(tostring(Result.Err(0)) == "Err<number>")
				assert(tostring(Result.Err(CFrame.identity)) == "Err<CFrame>")
			end).never.to.throw()
		end)

		it("should implement __eq metamethod", function()
			expect(function()
				assert(Result.Err() == Result.Err())
				assert(Result.Err(0) == Result.Err(0))
			end).never.to.throw()
		end)
	end)

	describe(":isOk()", function()
		it("should recognize Ok", function()
			expect(function()
				assert(Result.Ok():isOk() == true)
				assert(Result.Ok(0):isOk() == true)
				assert(Result.Ok({}):isOk() == true)
			end).never.to.throw()
		end)

		it("should recognize Err", function()
			expect(function()
				assert(Result.Err():isOk() == false)
				assert(Result.Err(0):isOk() == false)
				assert(Result.Err({}):isOk() == false)
			end).never.to.throw()
		end)
	end)

	describe(":isOkWith()", function()
		it("should throw an error if returned value is not a boolean", function()
			expect(function()
				Result.Ok(0):isOkWith(function() end)
			end).to.throw()

			expect(function()
				Result.Ok(0):isOkWith(function()
					return {}
				end)
			end).to.throw()

			expect(function()
				Result.Ok():isOkWith(function()
					return 0
				end)
			end).to.throw()
		end)

		it("should recognize Ok", function()
			expect(function()
				assert(Result.Ok():isOkWith(function()
					return false
				end) == false)
				assert(Result.Ok():isOkWith(function()
					return true
				end) == true)
			end).never.to.throw()
		end)

		it("should recognize Err", function()
			expect(function()
				assert(Result.Err():isOkWith(function()
					return false
				end) == false)
				assert(Result.Err():isOkWith(function()
					return true
				end) == false)
			end).never.to.throw()
		end)
	end)

	describe(":isErr()", function()
		it("should recognize Err", function()
			expect(function()
				assert(Result.Err():isErr() == true)
			end).never.to.throw()
		end)

		it("should recognize Ok", function()
			expect(function()
				assert(Result.Ok():isErr() == false)
			end).never.to.throw()
		end)
	end)

	describe(":isErrWith()", function()
		it("should throw an error if returned value is not a boolean", function()
			expect(function()
				Result.Ok():isErrWith(function() end)
			end).to.throw()

			expect(function()
				Result.Err():isErrWith(function()
					return {}
				end)
			end).to.throw()
		end)

		it("should recognize Err", function()
			expect(function()
				assert(Result.Err():isErrWith(function()
					return true
				end) == true)
				assert(Result.Err():isErrWith(function()
					return false
				end) == false)
			end).never.to.throw()
		end)

		it("should recognize Ok", function()
			expect(function()
				assert(Result.Ok():isErrWith(function()
					return true
				end) == false)
				assert(Result.Ok():isErrWith(function()
					return false
				end) == false)
			end).never.to.throw()
		end)
	end)

	describe(":ok()", function()
		return
	end)

	describe(":err()", function()
		return
	end)

	describe(":map()", function()
		it("should properly map Ok to another Ok", function()
			expect(function()
				assert(Result.Ok():map(function() end):isOk() == true)
				assert(Result.Ok()
					:map(function()
						return 0
					end)
					:isOkWith(function(v)
						return v == 0
					end) == true)
			end).never.to.throw()
		end)

		it("should not map Err to another Result", function()
			expect(function()
				local err = Result.Err()
				assert(err:map(function() end) == err)
				assert(err:map(function()
					return "newErr"
				end) == err)
			end).never.to.throw()
		end)

		it("should throw an error if no `op` function provided", function()
			expect(function()
				Result.Ok():map()
			end).to.throw()

			expect(function()
				Result.Err():map()
			end).to.throw()

			expect(function()
				Result.Ok():map({})
			end).to.throw()

			expect(function()
				Result.Err():map({})
			end).to.throw()
		end)
	end)

	describe(":mapOr()", function()
		it("should use default in case Result in Err", function()
			expect(function()
				assert(Result.Err():mapOr(0, function() end) == 0)
				assert(Result.Err(200):mapOr(nil, function() end) == nil)
			end).never.to.throw()
		end)

		it("should throw an error in case 'f' function is not provided", function()
			expect(function()
				Result.Ok():mapOr()
			end).to.throw()

			expect(function()
				Result.Ok():mapOr("key")
			end).to.throw()

			expect(function()
				Result.Ok():mapOr(nil, function() end)
			end).never.to.throw()

			expect(function()
				Result.Err():mapOr()
			end).to.throw()

			expect(function()
				Result.Err():mapOr(1000)
			end).to.throw()

			expect(function()
				Result.Err():mapOr(nil, function() end)
			end).never.to.throw()
		end)
	end)

	describe(":mapOrElse()", function()
		it("should throw an error in case 'default' function is not provided", function()
			expect(function()
				Result.Ok():mapOrElse()
			end).to.throw()

			expect(function()
				Result.Ok():mapOrElse(nil, function() end)
			end).to.throw()

			expect(function()
				Result.Err():mapOrElse()
			end).to.throw()

			expect(function()
				Result.Err():mapOrElse(nil, function() end)
			end).to.throw()
		end)

		it("should throw an error in case 'f' function is not provided", function()
			expect(function()
				Result.Ok():mapOrElse(function() end)
			end).to.throw()

			expect(function()
				Result.Err():mapOrElse(function() end)
			end).to.throw()
		end)
	end)

	describe(":mapErr()", function()
		it("should throw an error then no 'op' function provided", function()
			expect(function()
				Result.Ok():mapErr()
			end).to.throw()

			expect(function()
				Result.Err():mapErr()
			end).to.throw()

			expect(function()
				Result.Ok():mapErr({})
			end).to.throw()

			expect(function()
				Result.Err():mapErr({})
			end).to.throw()
		end)

		it("should properly map Err to another Err", function()
			expect(function()
				assert(Result.Err():mapErr(function()
					return 0
				end) == Result.Err(0))
			end).never.to.throw()
		end)

		it("should not map Ok to Err", function()
			expect(function()
				local ok = Result.Ok()
				assert(ok:mapErr(function()
					return 0
				end) == ok)
			end).never.to.throw()
		end)
	end)

	describe(":inspect()", function()
		it("should not throw an error when called on Err", function()
			expect(function()
				Result.Err():inspect(print)
			end).to.never.throw()

			expect(function()
				Result.Err():inspect(function() end)
			end).to.never.throw()
		end)

		it("should throw an error when no function provided", function()
			expect(function()
				Result.Ok():inspect()
			end).to.throw()

			expect(function()
				Result.Ok():inspect({})
			end).to.throw()
		end)

		it("should throw an error when inspect function returned atlease one value", function()
			expect(function()
				Result.Ok():inspect(function()
					return 0
				end)
			end).to.throw()

			expect(function()
				Result.Ok():inspect(print)
			end).never.to.throw()
		end)
	end)

	describe(":inspectErr()", function()
		it("should not throw an error when called on Ok", function()
			expect(function()
				Result.Ok():inspectErr(print)
			end).never.to.throw()

			expect(function()
				Result.Ok():inspectErr(function() end)
			end).never.to.throw()
		end)

		it("should throw an error when no function provided", function()
			expect(function()
				Result.Ok():inspectErr()
			end).to.throw()

			expect(function()
				Result.Ok():inspectErr({})
			end).to.throw()

			expect(function()
				Result.Err():inspectErr()
			end).to.throw()

			expect(function()
				Result.Err():inspectErr({})
			end).to.throw()
		end)

		it("should throw an error if atleas one value returned from function", function()
			expect(function()
				Result.Err():inspectErr(function()
					return 0
				end)
			end).to.throw()

			expect(function()
				Result.Err():inspectErr(function()
					return 1, 2, 3
				end)
			end).to.throw()

			expect(function()
				Result.Err():inspectErr(function()
					return
				end)
			end).never.to.throw()
		end)
	end)
end
