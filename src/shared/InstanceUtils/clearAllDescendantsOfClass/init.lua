local getDescendantsOfClass = require(script.Parent.getDescendantsOfClass)

local function clearAllDescendantsOfClass(parent: Instance, className: string)
	for _, descendant in getDescendantsOfClass(parent, className) do
		descendant:Destroy()
	end
end

return clearAllDescendantsOfClass
