local function clearAllDescendantsWhichIsA(parent: Instance, className: string)
	for _, descendant in parent:GetDescendants() do
		if descendant:IsA(className) then
			descendant:Destroy()
		end
	end
end

return clearAllDescendantsWhichIsA
