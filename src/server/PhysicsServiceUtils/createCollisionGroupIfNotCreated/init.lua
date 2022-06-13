local PhysicsService = game:GetService("PhysicsService")

local function createCollisionGroupIfNotCreated(collisionGroupName: string)
	-- looping thru all of the created collision groups and checking if their name is
	-- the same as the one that was provided, if so then return, otherwise do nothing
	for _, collisionGroup in PhysicsService:GetCollisionGroups() do
		if collisionGroup.name == collisionGroupName then
			return
		end
	end

	PhysicsService:CreateCollisionGroup(collisionGroupName)
end

return createCollisionGroupIfNotCreated
