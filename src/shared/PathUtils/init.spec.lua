return function()
	local PathUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			PathUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(PathUtils, {})
		end).to.throw()
	end)
end
