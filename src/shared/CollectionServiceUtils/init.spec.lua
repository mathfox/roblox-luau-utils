return function()
	local CollectionServiceUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			CollectionServiceUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(CollectionServiceUtils, {})
		end).to.throw()
	end)
end
