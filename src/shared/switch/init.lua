local function switch(condition, results: { [any]: any, _: any })
	local exists = results[condition] or results._
	return if type(exists) == "function" then exists() else exists
end

return switch
