local function loadChildren(parent: Instance)
	local modules: { any } = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("ModuleScript") then
			local m = require(child)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadChildren
