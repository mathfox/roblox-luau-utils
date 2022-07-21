local CollectionService = game:GetService("CollectionService")

local function findFirstAncestorOfTag(child: Instance, tag: string)
	while child.Parent do
		if CollectionService:HasTag(child.Parent, tag) then
			return child.Parent
		else
			child = child.Parent
		end
	end

	return nil
end

return findFirstAncestorOfTag
