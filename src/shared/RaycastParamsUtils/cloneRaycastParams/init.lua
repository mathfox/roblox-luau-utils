local function cloneRaycastParams(raycastParams: RaycastParams): RaycastParams
	local newRaycastParams = RaycastParams.new()

	newRaycastParams.CollisionGroup = raycastParams.CollisionGroup
	newRaycastParams.FilterType = raycastParams.FilterType
	newRaycastParams.FilterDescendantsInstances = raycastParams.FilterDescendantsInstances
	newRaycastParams.IgnoreWater = raycastParams.IgnoreWater

	return newRaycastParams
end

return cloneRaycastParams
