local function copy<K, V>(source: { [K]: V }): { [K]: V }
	local result = table.create(#source)

	for key, value in source do
		result[key] = if type(value) == "table" then copy(value) else value
	end

	return result
end

return copy
