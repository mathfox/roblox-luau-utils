local function loadDescendantsFilter(parent: Instance, predicate: (ModuleScript) -> boolean)
	if type(predicate) ~= "function" then
		error(("'predicate' (#2 argument) must be a function, got (%s) instead"):format(typeof(predicate)), 2)
	end

	local modules: { any } = {}

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA("ModuleScript") then
			local bool = predicate(descendant)
			if type(bool) ~= "boolean" then
				error(
					("'predicate' (#2 arugment) function must return a boolean, got (%s) instead"):format(typeof(bool)),
					2
				)
			end

			if bool then
				table.insert(modules, require(descendant))
			end
		end
	end

	return modules
end

return loadDescendantsFilter
