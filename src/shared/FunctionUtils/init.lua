local FunctionUtils = {
	bindArgs = require(script.bindArgs),
	returnArgs = require(script.returnArgs),
	void = require(script.void),
}

table.freeze(FunctionUtils)

return FunctionUtils
