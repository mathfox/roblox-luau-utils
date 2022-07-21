return function()
	local promiseSoundLoaded = require(script.Parent)

	it("should be a function", function()
		expect(promiseSoundLoaded).to.be.a("function")
	end)
end
