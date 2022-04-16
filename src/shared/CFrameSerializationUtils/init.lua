local CFrameSerializationUtils = {
	isSerializedCFrame = require(script.isSerializedCFrame),
	deserializeCFrame = require(script.deserializeCFrame),
	serializeCFrame = require(script.serializeCFrame),
}

table.freeze(CFrameSerializationUtils)

return CFrameSerializationUtils
