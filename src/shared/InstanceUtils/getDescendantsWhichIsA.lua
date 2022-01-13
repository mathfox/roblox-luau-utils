export type DescendantsWhichIsA = { Instance }

local function getDescendantsWhichIsA(parent: Instance, className: string): DescendantsWhichIsA
	local descendants: DescendantsWhichIsA = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA(className) then
			table.insert(descendants, descendant)
		end
	end

	return descendants
end

return getDescendantsWhichIsA
