local function findFirstDescendantWhichIsA(parent: Instance, className: string): Instance?
	local children: { Instance } = parent:GetChildren()

	for _, child in ipairs(children) do
		if child:IsA(className) then
			return child
		end
	end

	for _, child in ipairs(children) do
		local descendant: Instance? = findFirstDescendantWhichIsA(child, className)
		if descendant then
			return descendant
		end
	end

	return nil
end

return findFirstDescendantWhichIsA
