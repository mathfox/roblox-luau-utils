local function clearAllChildrenOfClass(parent: Instance, className: string)
	for _, child in parent:GetChildren() do
		if child.ClassName == className then
			child:Destroy()
		end
	end
end

return clearAllChildrenOfClass
