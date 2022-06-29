local function some<K, V>(source: { [K]: V }, predicate: (V, K, { [K]: V }) -> boolean)
	for key, value in source do
		if predicate(value, key, source) then
			return true
		end
	end

	return false
end

return some
