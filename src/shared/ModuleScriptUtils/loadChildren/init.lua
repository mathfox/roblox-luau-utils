local function loadChildren(parent: Instance)
	local modules: { any } = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("ModuleScript") then
			table.insert(modules, require(child))
		end
	end

	return modules
end

return loadChildren
