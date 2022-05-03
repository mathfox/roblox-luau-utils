return function()
	local void = require(script.Parent.Parent.void)
	local Signal = require(script.Parent)

	it('should throw an error when extra arguments provided to the "connect" method', function()
		local bool, message = pcall(function()
			Signal.new():connect(void, nil)
		end)

		expect(bool).to.equal(false)
		expect(message:match("expects exactly one function") ~= nil)
	end)
end
