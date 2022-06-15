local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function loadDescendantsFilter(parent: Instance, predicate: (ModuleScript) -> boolean)
	local modules: Array<any> = {}

	for _, descendant in parent:GetDescendants() do
		if descendant:IsA("ModuleScript") and predicate(descendant :: ModuleScript) then
			table.insert(modules, require(descendant :: ModuleScript))
		end
	end

	return modules
end

return loadDescendantsFilter
