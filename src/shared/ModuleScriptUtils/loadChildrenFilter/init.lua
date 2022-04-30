local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function loadChildrenFilter(parent: Instance, predicate: (ModuleScript) -> boolean)
	if type(predicate) ~= "function" then
		error(("'predicate' (#2 argument) must be a function, got (%s) instead"):format(typeof(predicate)), 2)
	end

	local modules: Array<any> = {}

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA("ModuleScript") then
			local bool = predicate(child :: ModuleScript)
			if type(bool) ~= "boolean" then
				error(("'predicate' (#2 argument) function provided to the 'loadChildrenFilter' function must return a boolean, got (%s) instead"):format(typeof(bool)), 2)
			end

			if bool then
				table.insert(modules, require(child :: ModuleScript))
			end
		end
	end

	return modules
end

return loadChildrenFilter
