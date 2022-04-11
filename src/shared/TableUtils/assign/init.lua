local function assign<K, V>(tbl: { [K]: V }, ...: { [K]: V }): { [K]: V }
	local new = table.clone(tbl)
	for _, t in ipairs({ ... }) do
		for k, v in pairs(t) do
			new[k] = v
		end
	end
	return new
end

return assign
