local function cloneRaycastParams(params: RaycastParams)
	local raycastParams = RaycastParams.new()

	raycastParams.CollisionGroup = params.CollisionGroup
	raycastParams.FilterType = params.FilterType
	raycastParams.FilterDescendantsInstances = params.FilterDescendantsInstances
	raycastParams.IgnoreWater = params.IgnoreWater

	return raycastParams
end

return cloneRaycastParams
