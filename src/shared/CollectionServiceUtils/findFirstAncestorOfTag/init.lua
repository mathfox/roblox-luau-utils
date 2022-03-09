local findFirstAncestorOfTagFast = require(script.Parent.findFirstAncestorOfTagFast)

local function findFirstAncestorOfTag(tagName: string, child: Instance)
	if tagName == nil then
		error("missing argument #1 to 'findFirstAncestorOfTag' (string expected)", 2)
	elseif type(tagName) ~= "string" then
		error(("invalid argument #1 to 'findFirstAncestorOfTag' (string expected, got %s)"):format(type(tagName)), 2)
	elseif child == nil then
		error("missing argument #2 to 'findFirstAncestorOfTag' (Instance expected)", 2)
	elseif typeof(child) ~= "Instance" then
		error(("invalid argument #2 to 'findFirstAncestorOfTag' (Instance expected, got %s)"):format(typeof(child)), 2)
	end

	return findFirstAncestorOfTagFast(tagName, child)
end

return findFirstAncestorOfTag
