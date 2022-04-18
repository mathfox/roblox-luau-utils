local function loadDescendants(parent: Instance)
	local modules: { any } = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA("ModuleScript") then
			table.insert(modules, require(descendant))
		end
	end

	return modules
end

return loadDescendants
