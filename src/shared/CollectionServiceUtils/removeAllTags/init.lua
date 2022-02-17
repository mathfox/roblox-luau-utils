local removeAllTagsFast = require(script.Parent.removeAllTagsFast)

local function removeAllTags(instance: Instance)
	if instance == nil then
		error("missing argument #1 to 'removeAllTags' (Instance expected)", 2)
	elseif typeof(instance) ~= "Instance" then
		error(("invalid argument #1 to 'removeAllTags' (Instance expected, got %s)"):format(typeof(instance)), 2)
	end

	removeAllTagsFast(instance)
end

return removeAllTags
