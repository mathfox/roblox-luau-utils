
local loggerMiddleware = require(script.loggerMiddleware)

local Rodux = {
	Store = require(script.Store),
	createReducer = require(script.createReducer),
	combineReducers = require(script.combineReducers),
	makeActionCreator = require(script.makeActionCreator),
	loggerMiddleware = loggerMiddleware.middleware,
	thunkMiddleware = require(script.thunkMiddleware),
}

table.freeze(Rodux)

return Rodux
