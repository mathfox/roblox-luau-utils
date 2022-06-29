local function map<K, V, R>(source: { [K]: V }, func: (V, K, { [K]: V }) -> R): { [K]: R }
	local result = table.create(#source)

	for key, value in source do
		result[key] = func(value, key, source)
	end

	return result
end

return map
