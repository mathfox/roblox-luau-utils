local function isSerializedColor3(color3: { number }): boolean
	return type(color3) == "table" and #color3 == 3
end

return isSerializedColor3
