local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function loadChildrenFilter(parent: Instance, predicate: (ModuleScript) -> boolean)
	local modules: Array<any> = {}

	for _, child in parent:GetChildren() do
		if child:IsA("ModuleScript") and predicate(child :: ModuleScript) then
			table.insert(modules, require(child :: ModuleScript))
		end
	end

	return modules
end

return loadChildrenFilter
