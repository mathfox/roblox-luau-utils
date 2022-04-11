local Types = require(script.Parent.Parent.Types)

type SerializedColor3 = Types.SerializedColor3

local function serializeColor3(color3: Color3): SerializedColor3
	return {
		math.floor(color3.R * 255),
		math.floor(color3.G * 255),
		math.floor(color3.B * 255),
	}
end

return serializeColor3
