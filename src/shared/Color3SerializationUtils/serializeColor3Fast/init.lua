local Types = require(script.Parent.Types)

local function serializeColor3Fast(color3: Color3): Types.SerializedColor3
	return {
		math.floor(color3.R * 255),
		math.floor(color3.G * 255),
		math.floor(color3.B * 255),
	}
end

return serializeColor3Fast
