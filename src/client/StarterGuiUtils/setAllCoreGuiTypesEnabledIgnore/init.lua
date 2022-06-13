local StarterGui = game:GetService("StarterGui")

local function setAllCoreGuiTypesEnabledIgnore(enabled: boolean, ignoreCoreGuiTypesList: { Enum.CoreGuiType })
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, enabled)

	for _, coreGuiType in ignoreCoreGuiTypesList do
		StarterGui:SetCoreGuiEnabled(coreGuiType, false)
	end
end

return setAllCoreGuiTypesEnabledIgnore
