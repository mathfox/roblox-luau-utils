local function isSerializedCFrame(object: any)
	return type(object) == "table" and #object == 12
end

return isSerializedCFrame
