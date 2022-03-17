local CollectionService = game:GetService("CollectionService")

local function hasTags(instance: Instance, tagNamesList: { string })
	for _, tagName in ipairs(tagNamesList) do
		if not CollectionService:HasTag(instance, tagName) then
			return false
		end
	end

	return true
end

return hasTags
