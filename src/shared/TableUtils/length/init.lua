local function length(tbl: { [any]: any })
	local l = 0
	for _ in pairs(tbl) do
		l += 1
	end
	return l
end

return length
