local StarterGui = game:GetService("StarterGui")

return function(enabled: boolean, list: { Enum.CoreGuiType })
	for _, coreGuiType in list do
		StarterGui:SetCoreGuiEnabled(coreGuiType, enabled)
	end
end
