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

local ModuleScriptLoader = {
	loadChildren = loadChildren,
	loadDescendants = loadDescendants,
}

return ModuleScriptLoader
