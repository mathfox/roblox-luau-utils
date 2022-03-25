local function copy<K, V>(tbl: { [K]: V })
	local new: { [K]: V } = table.create(#tbl)

	for k, v in pairs(tbl) do
		new[k] = if type(v) == "table" then copy(v) else v
	end

	return new
end

return copy
