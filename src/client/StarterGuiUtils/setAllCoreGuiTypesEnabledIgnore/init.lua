local StarterGui = game:GetService("StarterGui")

local Types = require(script.Parent.Types)

local function setAllCoreGuiTypesEnabledIgnore(enabled: boolean, ignoreCoreGuiTypesList: Types.CoreGuiTypesList)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, enabled)

	for _, coreGuiType in ipairs(ignoreCoreGuiTypesList) do
		StarterGui:SetCoreGuiEnabled(coreGuiType, false)
	end
end

return setAllCoreGuiTypesEnabledIgnore
