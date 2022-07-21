local CollectionService = game:GetService("CollectionService")

local function hasTags(instance: Instance, tagsList: { string })
	for _, tagName in tagsList do
		if not CollectionService:HasTag(instance, tagName) then
			return false
		end
	end

	return true
end

return hasTags
