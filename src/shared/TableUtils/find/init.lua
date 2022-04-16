local function find<K, V>(tbl: { [K]: V }, predicate: (V, K, { [K]: V }) -> boolean)
	for k, v in pairs(tbl) do
		if predicate(v, k, tbl) then
			return v, k
		end
	end
	return nil, nil
end

return find
