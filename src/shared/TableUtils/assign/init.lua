local function assign<K, V>(tbl: { [K]: V }, ...: { [K]: V }): { [K]: V }
	for _, t in ipairs({ ... }) do
		for k, v in pairs(t) do
			tbl[k] = v
		end
	end
	return tbl
end

return assign
