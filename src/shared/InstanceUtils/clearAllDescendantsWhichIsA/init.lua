local getDescendantsWhichIsA = require(script.Parent.getDescendantsWhichIsA)

local function clearAllDescendantsWhichIsA(parent: Instance, className: string)
	for _, descendant in getDescendantsWhichIsA(parent, className) do
		descendant:Destroy()
	end
end

return clearAllDescendantsWhichIsA
