return function()
	local RaycastParamsUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			RaycastParamsUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(RaycastParamsUtils, {})
		end).to.throw()
	end)
end
