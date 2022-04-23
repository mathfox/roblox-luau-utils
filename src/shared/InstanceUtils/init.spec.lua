return function()
	local InstanceUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			InstanceUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(InstanceUtils, {})
		end).to.throw()
	end)
end
