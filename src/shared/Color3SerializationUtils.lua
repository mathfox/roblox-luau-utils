local function serializeColor3(color3: Color3): { number }
	if typeof(color3) ~= "Color3" then
		error("#1 argument must be a Color3!", 2)
	end

	local floor = math.floor
	return {
		floor(color3.R * 255),
		floor(color3.G * 255),
		floor(color3.B * 255),
	}
end

local function isSerializedColor3(color3: { number }): boolean
	return type(color3) == "table" and #color3 == 3
end

local function deserializeColor3(color3: { number }): Color3
	if type(color3) ~= "table" then
		error("#1 argument must be a table!", 2)
	elseif #color3 ~= 3 then
		error("#1 argument must be a {number, number, number} table!", 2)
	end
	return Color3.fromRGB(table.unpack(color3))
end

local Color3SerializationUtils = {
	serializeColor3 = serializeColor3,
	deserializeColor3 = deserializeColor3,
	isSerializedColor3 = isSerializedColor3,
}

return Color3SerializationUtils
