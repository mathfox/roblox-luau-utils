local loadDescendantsFast = require(script.Parent.loadDescendantsFast)

local function loadDescendants(parent: Instance)
	if parent == nil then
		error("missing argument #1 to 'loadDescendants' (Instance expected)", 2)
	elseif typeof(parent) ~= "Instance" then
		error(("invalid argument #1 to 'loadDescendants' (Instance expected, got %s)"):format(typeof(parent)), 2)
	end

	return loadDescendantsFast(parent)
end

return loadDescendants
