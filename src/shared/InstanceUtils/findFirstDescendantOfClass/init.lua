local function findFirstDescendantOfClass(parent: Instance, className: string)
	local children = parent:GetChildren()

	for _, child in ipairs(children) do
		if child.ClassName == className then
			return child
		end
	end

	for _, child in ipairs(children) do
		local descendant: Instance? = findFirstDescendantOfClass(child, className)
		if descendant then
			return descendant :: Instance
		end
	end

	return nil
end

return findFirstDescendantOfClass
