local function clearAllDescendantsOfClass(parent: Instance, className: string)
	for _, descendant in parent:GetDescendants() do
		if descendant.ClassName == className then
			descendant:Destroy()
		end
	end
end

return clearAllDescendantsOfClass
