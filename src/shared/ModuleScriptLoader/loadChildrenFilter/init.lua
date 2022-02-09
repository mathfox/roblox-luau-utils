local function loadChildrenFilter(parent: Instance, predicate: (ModuleScript) -> boolean): { any }
	local modules = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("ModuleScript") and predicate(child) then
			local m = require(child)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadChildrenFilter
