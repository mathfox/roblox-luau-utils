local CollectionService = game:GetService("CollectionService")

local function removeAllTagsFast(instance: Instance)
	for _, tagName in ipairs(CollectionService:GetTags(instance)) do
		CollectionService:RemoveTag(instance, tagName)
	end
end

return removeAllTagsFast
