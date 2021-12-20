local CollectionService = game:GetService("CollectionService")

local function findFirstAncestorOfTag(tagName: string, child: Instance): Instance?
	if type(tagName) ~= "string" then
		error("#1 argument must be a string!", 2)
	elseif typeof(child) ~= "Instance" then
		error("#2 argument must be an Instance!", 2)
	end

	local current = child.Parent

	while current do
		if CollectionService:HasTag(current, tagName) then
			return current
		end
		current = current.Parent
	end

	return nil
end

local function removeAllTags(instance: Instance)
	if typeof(instance) ~= "Instance" then
		error("#1 argument must be an Instance!", 2)
	end

	for _, tagName in pairs(CollectionService:GetTags(instance)) do
		CollectionService:RemoveTag(instance, tagName)
	end
end

local CollectionServiceUtils = {
	findFirstAncestorOfTag = findFirstAncestorOfTag,
	FindFirstAncestorOfTag = findFirstAncestorOfTag,
	removeAllTags = removeAllTags,
	RemoveAllTags = removeAllTags,
}

return CollectionServiceUtils
