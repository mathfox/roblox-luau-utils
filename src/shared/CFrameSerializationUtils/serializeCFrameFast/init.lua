local Types = require(script.Parent.Types)

local function serializeCFrameFast(cframe: CFrame): Types.SerializedCFrame
	return { cframe:GetComponents() }
end

return serializeCFrameFast
