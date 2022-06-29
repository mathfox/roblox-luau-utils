local function filterArray<V>(arr: { V }, predicate: (V, number, { V }) -> boolean): { V }
	local new = table.create(#arr)

	for index, value in arr do
		if predicate(value, index, arr) then
			table.insert(new, value)
		end
	end

	return new
end

return filterArray
