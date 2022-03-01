local Types = require(script.Parent.Types)

local function deserializeCFrameFast(serializedCFrame: Types.SerializedCFrame)
	return CFrame.new(unpack(serializedCFrame))
end

return deserializeCFrameFast
