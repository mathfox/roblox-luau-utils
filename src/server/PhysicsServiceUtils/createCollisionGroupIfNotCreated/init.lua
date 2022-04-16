local PhysicsService = game:GetService("PhysicsService")

local function createCollisionGroupIfNotCreated(collisionGroupName: string)
	local collisionGroups = PhysicsService:GetCollisionGroups()

	-- loop thru all already created collision groups and check if their name is
	-- the same as the one was provided, if no then do nothing
	for _, collisionGroup in ipairs(collisionGroups) do
		if collisionGroup.name == collisionGroupName then
			return
		end
	end

	PhysicsService:CreateCollisionGroup(collisionGroupName)
end

return createCollisionGroupIfNotCreated
