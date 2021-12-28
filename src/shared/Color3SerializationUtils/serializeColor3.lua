local function serializeColor3(color3: Color3): { number }
	if color3 == nil then
		error("missing argument #1 to 'serializeColor3' (Color3 expected)", 2)
	elseif typeof(color3) ~= "Color3" then
		error(("invalid argument #1 to 'serializeColor3' (Color3 expected, got %s)"):format(typeof(color3)), 2)
	end

	local floor = math.floor

	return {
		floor(color3.R * 255),
		floor(color3.G * 255),
		floor(color3.B * 255),
	}
end

return serializeColor3
