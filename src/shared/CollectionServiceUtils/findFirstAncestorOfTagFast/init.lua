local CollectionService = game:GetService("CollectionService")

local function findFirstAncestorOfTagFast(tagName: string, child: Instance)
	local parent = child.Parent

	while parent do
		if CollectionService:HasTag(parent, tagName) then
			return parent
		else
			parent = parent.Parent
		end
	end

	return nil
end

return findFirstAncestorOfTagFast
