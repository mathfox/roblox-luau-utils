local getChildrenWhichIsA = require(script.Parent.getChildrenWhichIsA)

local function clearAllChildrenWhichIsA(parent: Instance, className: string)
	for _, child in getChildrenWhichIsA(parent, className) do
		child:Destroy()
	end
end

return clearAllChildrenWhichIsA
