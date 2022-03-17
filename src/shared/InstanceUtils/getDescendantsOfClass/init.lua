local function getDescendantsOfClass(parent: Instance, className: string)
	local descendants: { Instance } = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant.ClassName == className then
			table.insert(descendants, descendant)
		end
	end

	return descendants
end

return getDescendantsOfClass
