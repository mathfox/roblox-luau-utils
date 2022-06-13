local PhysicsService = game:GetService("PhysicsService")

local function doesCollisionGroupWithNameExist(collisionGroupName: string)
	for _, collisionGroupConfigurationTable in PhysicsService:GetCollisionGroups() do
		if collisionGroupConfigurationTable.name == collisionGroupName then
			return true
		end
	end

	return false
end

return doesCollisionGroupWithNameExist
