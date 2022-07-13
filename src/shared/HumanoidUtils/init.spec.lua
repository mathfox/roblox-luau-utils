return function()
	local HumanoidUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			HumanoidUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(HumanoidUtils, {})
		end).to.throw()
	end)
end
