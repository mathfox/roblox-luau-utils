return function()
	local FriendUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			FriendUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(FriendUtils, {})
		end).to.throw()
	end)
end
