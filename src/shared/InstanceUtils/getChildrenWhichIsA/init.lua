local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function getChildrenWhichIsA(parent: Instance, className: string)
	local children = parent:GetChildren()
	local arr: Array<Instance> = table.create(#children)

	for _, child in ipairs(children) do
		if child:IsA(className) then
			table.insert(arr, child)
		end
	end

	return arr
end

return getChildrenWhichIsA
