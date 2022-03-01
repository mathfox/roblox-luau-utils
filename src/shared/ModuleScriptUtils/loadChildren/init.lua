local loadChildrenFast = require(script.Parent.loadChildrenFast)

local function loadChildren(parent: Instance)
	if parent == nil then
		error("missing argument #1 to 'loadChildren' (Instance expected)", 2)
	elseif typeof(parent) ~= "Instance" then
		error(("invalid argument #1 to 'loadChildren' (Instance expected, got %s)"):format(typeof(parent)), 2)
	end

	return loadChildrenFast(parent)
end

return loadChildren
