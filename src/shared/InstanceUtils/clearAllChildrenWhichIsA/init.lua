local function clearAllChildrenWhichIsA(parent: Instance, className: string)
	for _, child in parent:GetChildren() do
		if child:IsA(className) then
			child:Destroy()
		end
	end
end

return clearAllChildrenWhichIsA
