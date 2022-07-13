local function copy<K, V>(source: { [K]: V }): { [K]: V }
	local result = table.clone(source)

	for key, value in result do
		if type(value) == "table" then
			result[key] = copy(value)
		end
	end

	return result
end

return copy
