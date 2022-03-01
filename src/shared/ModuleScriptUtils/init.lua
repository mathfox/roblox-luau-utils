local ModuleScriptUtils = {
	loadChildren = require(script.loadChildren),
	loadChildrenFast = require(script.loadChildrenFast),

	loadChildrenFilter = require(script.loadChildrenFilter),
	loadChildrenFilterFast = require(script.loadChildrenFilterFast),

	loadDescendants = require(script.loadDescendants),
	loadDescendantsFast = require(script.loadDescendantsFast),

	loadDescendantsFilter = require(script.loadDescendantsFilter),
	loadDescendantsFilterFast = require(script.loadDescendantsFilterFast),
}

return ModuleScriptUtils
