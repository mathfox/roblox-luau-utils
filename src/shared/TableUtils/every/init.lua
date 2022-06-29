local function every<K, V>(source: { [K]: V }, predicate: (V, K, { [K]: V }) -> boolean)
	for key, value in source do
		if not predicate(value, key, source) then
			return false
		end
	end

	return true
end

return every
