local function find<K, V>(source: { [K]: V }, predicate: (V, K, { [K]: V }) -> boolean)
	for key, value in source do
		if predicate(value, key, source) then
			return value, key
		end
	end

	return nil, nil
end

return find
