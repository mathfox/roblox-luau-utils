local Types = require(script.Parent.Parent.TableUtils.Types)

local function loadDescendantsFast(parent: Instance)
	local modules: Types.GenericList = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA("ModuleScript") then
			local m = require(descendant)
			table.insert(modules, m)
		end
	end

	return modules
end

return loadDescendantsFast
