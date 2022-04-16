local FunctionUtils = {
	returnArgs = require(script.returnArgs),
	bindArgs = require(script.bindArgs),
	void = require(script.void),
}

table.freeze(FunctionUtils)

return FunctionUtils
