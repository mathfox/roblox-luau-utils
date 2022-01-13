export type ChildrenOfClass = { Instance }

local function getChildrenOfClass(parent: Instance, className: string): ChildrenOfClass
	local children: ChildrenOfClass = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child.ClassName == className then
			table.insert(children, child)
		end
	end

	return children
end

return getChildrenOfClass
