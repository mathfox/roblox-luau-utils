local function keys<K>(tbl: { [K]: any }): { K }
	local new = table.create(#tbl)
	for k in pairs(tbl) do
		table.insert(new, k)
	end
	return new
end

return keys
