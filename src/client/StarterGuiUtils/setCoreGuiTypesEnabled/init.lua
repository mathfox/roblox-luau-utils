local StarterGui = game:GetService("StarterGui")

local Types = require(script.Parent.Types)

local function setCoreGuiTypesEnabled(enabled: boolean, coreGuiTypesList: Types.CoreGuiTypesList)
	for _, coreGuiType in ipairs(coreGuiTypesList) do
		StarterGui:SetCoreGuiEnabled(coreGuiType, enabled)
	end
end

return setCoreGuiTypesEnabled
