local CollectionService = game:GetService("CollectionService")

local function removeAllTags(instance: Instance)
	for _, tagName in CollectionService:GetTags(instance) do
		CollectionService:RemoveTag(instance, tagName)
	end
end

return removeAllTags
