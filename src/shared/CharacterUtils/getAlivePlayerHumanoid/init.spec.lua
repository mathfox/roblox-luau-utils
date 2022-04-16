return function()
	local getAlivePlayerHumanoid = require(script.Parent)

	it("should return renamed alive humanoid", function()
		expect(function()
			local character = Instance.new("Folder")
			local humanoid = Instance.new("Humanoid", character)
			humanoid.Name = "5ed11d91-0642-532d-8bbd-c06fdf67d3cd"
			assert(getAlivePlayerHumanoid({ Character = character }) == humanoid)
			humanoid.Health = 0
			assert(getAlivePlayerHumanoid({ Character = character }) == nil)
		end).never.to.throw()
	end)
end
