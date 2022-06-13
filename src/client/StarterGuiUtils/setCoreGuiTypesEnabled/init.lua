local StarterGui = game:GetService("StarterGui")

local function setCoreGuiTypesEnabled(enabled: boolean, coreGuiTypesList: { Enum.CoreGuiType })
	for _, coreGuiType in coreGuiTypesList do
		StarterGui:SetCoreGuiEnabled(coreGuiType, enabled)
	end
end

return setCoreGuiTypesEnabled
