local function override<K, V>(tbl: { [K]: V }, overridingTbl: { [K]: V }): { [K]: V }
	local new = table.clone(tbl)
	for k, v in pairs(overridingTbl) do
		new[k] = if type(v) == "table"
			then if type(new[k]) == "table" then override(new[k], v) else table.clone(v)
			else v
	end
	return new
end

return override
