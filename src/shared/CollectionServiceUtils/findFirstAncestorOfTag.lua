local CollectionService = game:GetService("CollectionService")

local function findFirstAncestorOfTag(tagName: string, child: Instance): Instance?
	if tagName == nil then
		error("missing argument #1 to 'findFirstAncestorOfTag' (string expected)", 2)
	elseif type(tagName) ~= "string" then
		error(("invalid argument #1 to 'findFirstAncestorOfTag' (string expected, got %s)"):format(type(tagName)), 2)
	elseif child == nil then
		error("missing argument #2 to 'findFirstAncestorOfTag' (Instance expected)", 2)
	elseif typeof(child) ~= "Instance" then
		error(("invalid argument #2 to 'findFirstAncestorOfTag' (Instance expected, got %s)"):format(typeof(child)), 2)
	end

	local parent = child.Parent

	while parent do
		if CollectionService:HasTag(parent, tagName) then
			return parent
		end

		parent = parent.Parent
	end

	return nil
end

return findFirstAncestorOfTag
