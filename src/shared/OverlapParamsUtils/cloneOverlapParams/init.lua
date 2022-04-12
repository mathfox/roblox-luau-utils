local function cloneOverlapParams(params: OverlapParams)
	local newParams = OverlapParams.new()
	newParams.FilterDescendantsInstances = params.FilterDescendantsInstances
	newParams.FilterType = params.FilterType
	newParams.MaxParts = params.MaxParts
	newParams.CollisionGroup = params.CollisionGroup
	return newParams
end

return cloneOverlapParams
