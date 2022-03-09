local function isSerializedCFrame(object)
	return type(object) == "table" and #object == 12
end

return isSerializedCFrame
