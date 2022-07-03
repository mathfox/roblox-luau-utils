local FunctionUtils = {
	bindArgs = require(script.bindArgs),
	noop = require(script.noop),
	returnArgs = require(script.returnArgs),
	void = require(script.void),
}

table.freeze(FunctionUtils)

return FunctionUtils
