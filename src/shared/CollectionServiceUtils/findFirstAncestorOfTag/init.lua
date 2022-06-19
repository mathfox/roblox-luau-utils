local CollectionService = game:GetService("CollectionService")

local function findFirstAncestorOfTag(child: Instance, tagName: string)
	while child.Parent do
		if CollectionService:HasTag(child.Parent, tagName) then
			return child.Parent
		else
			child = child.Parent
		end
	end

	return nil
end

return findFirstAncestorOfTag
