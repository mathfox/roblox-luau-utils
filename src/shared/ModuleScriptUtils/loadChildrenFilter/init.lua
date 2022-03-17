local function loadChildrenFilter(parent: Instance, predicate: (ModuleScript) -> boolean)
	local modules: { any } = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("ModuleScript") and predicate(child) then
			local m = require(child)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadChildrenFilter
