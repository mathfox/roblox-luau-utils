local function length(source: { [any]: any })
	local amount = 0

	for _ in source do
		amount += 1
	end

	return amount
end

return length
