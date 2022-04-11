local function reverse<V>(tbl: { V }): { V }
	local n = #tbl
	local new = table.create(n)
	for i = 1, n do
		new[i] = tbl[n - i + 1]
	end
	return new
end

return reverse
