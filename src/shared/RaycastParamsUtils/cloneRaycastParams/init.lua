local function cloneRaycastParams(params: RaycastParams)
	local newParams = RaycastParams.new()
	newParams.CollisionGroup = params.CollisionGroup
	newParams.FilterType = params.FilterType
	newParams.FilterDescendantsInstances = params.FilterDescendantsInstances
	newParams.IgnoreWater = params.IgnoreWater
	return newParams
end

return cloneRaycastParams
