local ModuleScriptLoader = {
	loadChildren = require(script.loadChildren),
	loadChildrenFilter = require(script.loadChildrenFilter),

	loadDescendants = require(script.loadDescendants),
	loadDescendantsFilter = require(script.loadDescendantsFilter),
}

return ModuleScriptLoader
