export type ChildrenWhichIsA = { Instance }

local function getChildrenWhichIsA(parent: Instance, className: string): ChildrenWhichIsA
	local children: ChildrenWhichIsA = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA(className) then
			table.insert(children, child)
		end
	end

	return children
end

return getChildrenWhichIsA
