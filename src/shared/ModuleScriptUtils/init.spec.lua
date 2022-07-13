return function()
	local ModuleScriptUtils = require(script.Parent)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			ModuleScriptUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(ModuleScriptUtils, {})
		end).to.throw()
	end)
end
