local function keys<K>(source: { [K]: any }): { K }
	local result = table.create(#source)

	for key in source do
		table.insert(result, key)
	end

	return result
end

return keys
