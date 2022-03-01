local loadDescendantsFilterFast = require(script.Parent.loadDescendantsFilterFast)

local function loadDescendantsFilter(parent: Instance, predicate: (ModuleScript) -> boolean)
	if parent == nil then
		error("missing argument #1 to 'loadDescendantsFilter' (Instance expected)", 2)
	elseif typeof(parent) ~= "Instance" then
		error(("invalid argument #1 to 'loadDescendantsFilter' (Instance expected, got %s)"):format(typeof(parent)), 2)
	elseif predicate == nil then
		error("missing argument #2 to 'loadDescendantsFilter' (function expected)", 2)
	elseif type(predicate) ~= "function" then
		error(
			("invalid argument #2 to 'loadDescendantsFilter' (function expected, got %s)"):format(typeof(predicate)),
			2
		)
	end

	return loadDescendantsFilterFast(parent, predicate)
end

return loadDescendantsFilter
