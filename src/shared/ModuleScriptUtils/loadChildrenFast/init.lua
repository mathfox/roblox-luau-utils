local Types = require(script.Parent.Parent.TableUtils.Types)

local function loadChildrenFast(parent: Instance)
	local modules: Types.GenericList = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("ModuleScript") then
			local m = require(child)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadChildrenFast
