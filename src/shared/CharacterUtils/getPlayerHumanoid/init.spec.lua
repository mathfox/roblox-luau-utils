return function()
	local getPlayerHumanoid = require(script.Parent)

	it("should return renamed humanoid", function()
		expect(function()
			local character = Instance.new("Folder")
			local humanoid = Instance.new("Humanoid", character)
			humanoid.Name = "5ed11d91-0642-532d-8bbd-c06fdf67d3cd"
			assert(getPlayerHumanoid({ Character = character }) == humanoid)
		end).never.to.throw()
	end)
end
