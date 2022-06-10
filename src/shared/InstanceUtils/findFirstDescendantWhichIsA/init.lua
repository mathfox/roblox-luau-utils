local function findFirstDescendantWhichIsA(parent: Instance, className: string)
	local children = parent:GetChildren()

	for _, child in children do
		if child:IsA(className) then
			return child
		end
	end

	for _, child in children do
		local descendant: Instance? = findFirstDescendantWhichIsA(child, className)
		if descendant then
			return descendant :: Instance
		end
	end

	return nil
end

return findFirstDescendantWhichIsA
