local Types = require(script.Parent.Types)

local function serializeCFrame(cframe: CFrame): Types.SerializedCFrame
	return { cframe:GetComponents() }
end

return serializeCFrame
