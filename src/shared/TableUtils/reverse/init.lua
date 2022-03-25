local function reverse<V>(tbl: { V })
	local n = #tbl
	local new: { V } = table.create(n)

	for i = 1, n do
		new[i] = tbl[n - i + 1]
	end

	return new
end

return reverse
