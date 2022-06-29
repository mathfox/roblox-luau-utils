local function values<V>(source: { [any]: V }): { V }
	local result = table.create(#source)

	for _, value in source do
		table.insert(result, value)
	end

	return result
end

return values
