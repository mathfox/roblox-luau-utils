local function loadChildren(parent: Instance): { any }
	local modules = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("ModuleScript") then
			local m = require(child)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadChildren
