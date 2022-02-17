local CollectionService = game:GetService("CollectionService")

local function findFirstAncestorOfTagFast(tagName: string, child: Instance): Instance?
	local parent = child.Parent

	while parent do
		if CollectionService:HasTag(parent, tagName) then
			return parent
		end

		parent = parent.Parent
	end

	return nil
end

return findFirstAncestorOfTagFast
