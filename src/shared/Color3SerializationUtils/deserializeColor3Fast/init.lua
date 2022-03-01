local Types = require(script.Parent.Types)

local function deserializeColor3Fast(serializedColor3: Types.SerializedColor3): Color3
	return Color3.fromRGB(unpack(serializedColor3))
end

return deserializeColor3Fast
