local getChildrenOfClass = require(script.Parent.getChildrenOfClass)

local function clearAllChildrenOfClass(parent: Instance, className: string)
	for _, child in ipairs(getChildrenOfClass(parent, className)) do
		child:Destroy()
	end
end

return clearAllChildrenOfClass
