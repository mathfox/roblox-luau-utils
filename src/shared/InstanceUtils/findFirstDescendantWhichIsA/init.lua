local function findFirstDescendantWhichIsA(parent: Instance, className: string)
	for _, descendant in parent:GetDescendants() do
		if descendant:IsA(className) then
			return descendant
		end
	end

	return nil
end

return findFirstDescendantWhichIsA
