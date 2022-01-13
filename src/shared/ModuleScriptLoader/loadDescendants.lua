local function loadDescendants(parent: Instance): { any }
	local modules = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA("ModuleScript") then
			local m = require(descendant)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadDescendants
