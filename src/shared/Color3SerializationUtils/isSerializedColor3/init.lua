local function isSerializedColor3(object: any)
	return type(object) == "table" and #object == 3
end

return isSerializedColor3
