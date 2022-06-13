local PhysicsService = game:GetService("PhysicsService")

local function doesCollisionGroupWithIdExist(collisionGroupId: number)
	for _, collisionGroupConfigurationTable in PhysicsService:GetCollisionGroups() do
		if collisionGroupConfigurationTable.id == collisionGroupId then
			return true
		end
	end

	return false
end

return doesCollisionGroupWithIdExist
