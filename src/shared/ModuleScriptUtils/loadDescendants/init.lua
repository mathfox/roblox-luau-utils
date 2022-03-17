local function loadDescendants(parent: Instance)
	local modules: { any } = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA("ModuleScript") then
			local m = require(descendant)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadDescendants
