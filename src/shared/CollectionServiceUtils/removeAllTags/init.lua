local CollectionService = game:GetService("CollectionService")

local function removeAllTags(instance: Instance)
	for _, tag in CollectionService:GetTags(instance) do
		CollectionService:RemoveTag(instance, tag)
	end
end

return removeAllTags
