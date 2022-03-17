local CollectionService = game:GetService("CollectionService")

local function findFirstAncestorOfTag(child: Instance, tagName: string)
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

return findFirstAncestorOfTag
