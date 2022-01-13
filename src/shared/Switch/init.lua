local function Switch(condition: any, results: { [any]: any, default: any }): any
	local exists = results[condition] or results.default
	return if type(exists) == "function" then exists() else exists
end

return Switch
