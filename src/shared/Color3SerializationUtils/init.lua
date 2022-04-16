local Color3SerializationUtils = {
	isSerializedColor3 = require(script.isSerializedColor3),
	deserializeColor3 = require(script.deserializeColor3),
	serializeColor3 = require(script.serializeColor3),
}

table.freeze(Color3SerializationUtils)

return Color3SerializationUtils
