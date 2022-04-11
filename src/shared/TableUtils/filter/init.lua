local function filter<K, V>(tbl: { [K]: V }, predicate: (v: V, k: K, tbl: { [K]: V }) -> boolean): { [K]: V }
	local new = table.create(#tbl)
	if #tbl > 0 then
		for i, v in ipairs(tbl) do
			if predicate(v, i, tbl) then
				table.insert(new, v)
			end
		end
	else
		for k, v in pairs(tbl) do
			if predicate(v, k, tbl) then
				new[k] = v
			end
		end
	end
	return new
end

return filter
