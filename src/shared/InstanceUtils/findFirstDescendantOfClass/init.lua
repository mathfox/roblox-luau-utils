local function findFirstDescendantOfClass(parent: Instance, className: string): Instance?
	local children: { Instance } = parent:GetChildren()

	for _, child in ipairs(children) do
		if child.ClassName == className then
			return child
		end
	end

	for _, child in ipairs(children) do
		local descendant: Instance? = findFirstDescendantOfClass(child, className)
		if descendant then
			return descendant
		end
	end

	return nil
end

return findFirstDescendantOfClass
