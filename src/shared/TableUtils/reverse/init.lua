local function reverse<V>(arr: { V }): { V }
	local length = #arr
	local new = table.create(length)

	for index = 1, length do
		new[index] = arr[length - index + 1]
	end

	return new
end

return reverse
