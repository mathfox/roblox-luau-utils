local function getChildrenWhichIsA(parent: Instance, className: string)
	local children: { Instance } = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA(className) then
			table.insert(children, child)
		end
	end

	return children
end

return getChildrenWhichIsA
