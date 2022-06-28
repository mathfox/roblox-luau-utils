local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function loadDescendants(parent: Instance): Array<any>
	local modules = {}

	for _, descendant in parent:GetDescendants() do
		if descendant:IsA("ModuleScript") then
			table.insert(modules, require(descendant :: ModuleScript))
		end
	end

	return modules
end

return loadDescendants
