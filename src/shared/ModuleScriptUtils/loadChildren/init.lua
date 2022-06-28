local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function loadChildren(parent: Instance): Array<any>
	local modules = {}

	for _, child in parent:GetChildren() do
		if child:IsA("ModuleScript") then
			table.insert(modules, require(child :: ModuleScript))
		end
	end

	return modules
end

return loadChildren
