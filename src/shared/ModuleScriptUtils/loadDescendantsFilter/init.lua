local function loadDescendantsFilter(parent: Instance, predicate: (ModuleScript) -> boolean)
	local modules: { any } = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA("ModuleScript") and predicate(descendant) then
			local m = require(descendant)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadDescendantsFilter
