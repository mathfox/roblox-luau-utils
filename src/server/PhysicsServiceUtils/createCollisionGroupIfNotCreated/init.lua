local PhysicsService = game:GetService("PhysicsService")

local function createCollisionGroupIfNotCreated(collisionGroupName: string)
	for _, collisionGroup in PhysicsService:GetCollisionGroups() do
		if collisionGroup.name == collisionGroupName then
			return
		end
	end

	PhysicsService:CreateCollisionGroup(collisionGroupName)
end

return createCollisionGroupIfNotCreated
