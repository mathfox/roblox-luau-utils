local CollectionService = game:GetService("CollectionService")

local function removeAllTagsFast(instance: Instance)
	local tagNamesList = CollectionService:GetTags(instance)

	for _, tagName in ipairs(tagNamesList) do
		CollectionService:RemoveTag(instance, tagName)
	end
end

return removeAllTagsFast
