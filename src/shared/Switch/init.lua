local function Switch(condition: any, results: { [any]: any, default: any }): any
	local exists = results[condition] or results.default
	if type(exists) == "function" then
		return exists()
	end
	return exists
end

return Switch
