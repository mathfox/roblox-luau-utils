local Types = require(script.Parent.Types)

local function deserializeCFrame(serializedCFrame: Types.SerializedCFrame)
	return CFrame.new(unpack(serializedCFrame))
end

return deserializeCFrame
