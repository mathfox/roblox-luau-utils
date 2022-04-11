local function values<V>(tbl: { [any]: V }): { V }
	local new = table.create(#tbl)
	for _, v in pairs(tbl) do
		table.insert(new, v)
	end
	return new
end

return values
