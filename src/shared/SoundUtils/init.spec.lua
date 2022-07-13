return function()
	local SoundUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			SoundUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(SoundUtils, {})
		end).to.throw()
	end)
end
