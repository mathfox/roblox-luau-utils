local loadChildrenFilterFast = require(script.Parent.loadChildrenFilterFast)

local function loadChildrenFilter(parent: Instance, predicate: (ModuleScript) -> boolean)
	if parent == nil then
		error("missing argument #1 to 'loadChildrenFilter' (Instance expected)", 2)
	elseif typeof(parent) ~= "Instance" then
		error(("invalid argument #1 to 'loadChildrenFilter' (Instance expected, got %s)"):format(typeof(parent)), 2)
	elseif predicate == nil then
		error("missing argument #2 to 'loadChildrenFilter' (function expected)", 2)
	elseif type(predicate) ~= "function" then
		error(("invalid argument #2 to 'loadChildrenFilter' (function expected, got %s)"):format(typeof(predicate)), 2)
	end

	return loadChildrenFilterFast(parent, predicate)
end

return loadChildrenFilter
