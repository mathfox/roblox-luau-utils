local Types = require(script.Parent.Parent.Types)

type SerializedColor3 = Types.SerializedColor3

local function deserializeColor3(serializedColor3: SerializedColor3)
	return Color3.fromRGB(unpack(serializedColor3))
end

return deserializeColor3
