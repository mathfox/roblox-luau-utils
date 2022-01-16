local StarterGui = game:GetService("StarterGui")

local function setAllCoreGuiEnabledIgnore(enabled: boolean, ignoreCoreGuiTypeList: { Enum.CoreGuiType })
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, enabled)

	for _, coreGuiType in ipairs(ignoreCoreGuiTypeList) do
		StarterGui:SetCoreGuiEnabled(coreGuiType, false)
	end
end

return setAllCoreGuiEnabledIgnore
