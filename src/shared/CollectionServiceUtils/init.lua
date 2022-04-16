local CollectionServiceUtils = {
	findFirstAncestorOfTag = require(script.findFirstAncestorOfTag),
	removeAllTags = require(script.removeAllTags),
	hasTags = require(script.hasTags),
}

table.freeze(CollectionServiceUtils)

return CollectionServiceUtils
