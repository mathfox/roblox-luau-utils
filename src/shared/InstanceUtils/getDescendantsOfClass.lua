export type DescendantsOfClass = { Instance }

local function getDescendantsOfClass(parent: Instance, className: string): DescendantsOfClass
	local descendants: DescendantsOfClass = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant.ClassName == className then
			table.insert(descendants, descendant)
		end
	end

	return descendants
end

return getDescendantsOfClass
