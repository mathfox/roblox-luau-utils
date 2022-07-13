return function()
	local Vector3Utils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			Vector3Utils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(Vector3Utils, {})
		end).to.throw()
	end)
end
