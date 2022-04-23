return function()
	local BasePartUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			BasePartUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(BasePartUtils, {})
		end).to.throw()
	end)
end
