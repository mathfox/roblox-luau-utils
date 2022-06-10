local CollectionService = game:GetService("CollectionService")

local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function hasTags(instance: Instance, tagNamesList: Array<string>)
	for _, tagName in tagNamesList do
		if not CollectionService:HasTag(instance, tagName) then
			return false
		end
	end

	return true
end

return hasTags
