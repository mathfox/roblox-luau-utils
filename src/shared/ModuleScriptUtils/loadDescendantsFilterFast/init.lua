local Types = require(script.Parent.Parent.TableUtils.Types)

local function loadDescendantsFilterFast(parent: Instance, predicate: (ModuleScript) -> boolean)
	local modules: Types.GenericList = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA("ModuleScript") and predicate(descendant) then
			local m = require(descendant)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadDescendantsFilterFast
