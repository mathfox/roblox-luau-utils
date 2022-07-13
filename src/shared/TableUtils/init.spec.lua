return function()
	local TableUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			TableUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(TableUtils, {})
		end).to.throw()
	end)
end
