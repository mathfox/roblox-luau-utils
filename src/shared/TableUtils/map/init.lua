local function map<K, V>(tbl: { [K]: V }, func: (v: V, k: K, tbl: { [K]: V }) -> any)
	local new: { [K]: V } = table.create(#tbl)

	for k, v in pairs(tbl) do
		new[k] = func(v, k, tbl)
	end

	return new
end

return map
