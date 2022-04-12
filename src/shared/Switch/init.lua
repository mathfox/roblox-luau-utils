local function switch(condition, results: { [any]: any, default: any })
	local exists = results[condition] or results.default
	return if type(exists) == "function" then exists() else exists
end

return switch
