return function()
	local getAlivePlayerRootPart = require(script.Parent)

	it("should be a function", function()
		expect(getAlivePlayerRootPart).to.be.a("function")
	end)

	it("should support renamed humanoids", function()
		expect(function()
			local character = Instance.new("Folder")
			local humanoid = Instance.new("Humanoid", character)
			humanoid.Name = "8383ac8d-59ef-5554-b0ce-7d34337801e5"

			local player = { Character = character }
			assert(getAlivePlayerRootPart(player) == nil)

			local rootPart = Instance.new("Part")
			rootPart.Name = "HumanoidRootPart"
			rootPart.Parent = character
			assert(getAlivePlayerRootPart(player) == rootPart)

			humanoid.Health = 0
			assert(getAlivePlayerRootPart(player) == nil)
			humanoid.Health = math.huge
			assert(getAlivePlayerRootPart(player) == rootPart)
		end).never.to.throw()
	end)
end
