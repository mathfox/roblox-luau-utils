return function()
	local promiseAllSoundsLoaded = require(script.Parent)

	it("should be a function", function()
		expect(promiseAllSoundsLoaded).to.be.a("function")
	end)
end
