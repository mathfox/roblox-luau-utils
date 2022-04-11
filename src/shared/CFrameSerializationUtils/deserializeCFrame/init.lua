local Types = require(script.Parent.Parent.Types)

type SerializedCFrame = Types.SerializedCFrame

local function deserializeCFrame(serializedCFrame: SerializedCFrame)
	return CFrame.new(unpack(serializedCFrame))
end

return deserializeCFrame
