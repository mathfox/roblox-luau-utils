local Types = require(script.Parent.Parent.Types)

type SerializedCFrame = Types.SerializedCFrame

local function serializeCFrame(cframe: CFrame): SerializedCFrame
	return { cframe:GetComponents() }
end

return serializeCFrame
