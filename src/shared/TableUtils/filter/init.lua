local function filter<K, V>(source: { [K]: V }, predicate: (V, K, { [K]: V }) -> boolean): { [K]: V }
	local new = {}

	for key, value in source do
		if predicate(value, key, source) then
			new[key] = value
		end
	end

	return new
end

return filter
