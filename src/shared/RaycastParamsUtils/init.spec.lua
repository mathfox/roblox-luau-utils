return function()
	local RaycastParamsUtils = require(script.Parent)

   it('should be a table', function()
      expect(RaycastParamsUtils).to.be.a('table')
   end)

   it('should not contain a metatable', function()
      expect(getmetatable(RaycastParamsUtils)).to.equal(nil)
   end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			RaycastParamsUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(RaycastParamsUtils, {})
		end).to.throw()
	end)
end
