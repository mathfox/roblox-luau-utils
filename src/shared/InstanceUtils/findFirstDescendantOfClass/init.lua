local function findFirstDescendantOfClass(parent: Instance, className: string)
	for _, descendant in parent:GetDescendants() do
		if descendant.ClassName == className then
			return descendant
		end
	end

	return nil
end

return findFirstDescendantOfClass
