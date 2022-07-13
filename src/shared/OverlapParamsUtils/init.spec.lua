return function()
	local OverlapParamsUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			OverlapParamsUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(OverlapParamsUtils, {})
		end).to.throw()
	end)
end
