local getChildrenOfClass = require(script.Parent.getChildrenOfClass)

local function clearAllChildrenOfClass(parent: Instance, className: string)
	for _, child in getChildrenOfClass(parent, className) do
		child:Destroy()
	end
end

return clearAllChildrenOfClass
