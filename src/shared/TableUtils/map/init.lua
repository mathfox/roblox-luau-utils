local function map<K, V>(tbl: { [K]: V }, func: (V, K, { [K]: V }) -> any): { [K]: V }
	local new = table.create(#tbl)
	for k, v in pairs(tbl) do
		new[k] = func(v, k, tbl)
	end
	return new
end

return map
