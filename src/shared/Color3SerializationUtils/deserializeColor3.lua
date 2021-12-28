local function deserializeColor3(serializedColor3: { number }): Color3
	if serializedColor3 == nil then
		error("missing argument #1 to 'deserializeColor3' (table expected)", 2)
	elseif type(serializedColor3) ~= "table" then
		error(("invalid argument #1 to 'deserializeColor3' (table expected, got %s)"):format(type(serializedColor3)), 2)
	end

	return Color3.fromRGB(table.unpack(serializedColor3))
end

return deserializeColor3
