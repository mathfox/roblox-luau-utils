local function every<K, V>(tbl: { [K]: V }, predicate: (V, K, { [K]: V }) -> boolean)
	for k, v in pairs(tbl) do
		if not predicate(v, k, tbl) then
			return false
		end
	end
	return true
end

return every
