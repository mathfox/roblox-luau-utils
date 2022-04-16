local function some<K, V>(tbl: { [K]: V }, predicate: (V, K, { [K]: V }) -> boolean)
	for k, v in pairs(tbl) do
		if predicate(v, k, tbl) then
			return true
		end
	end
	return false
end

return some
