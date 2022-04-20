local loggerMiddleware = require(script.loggerMiddleware)
local thunkMiddleware = require(script.thunkMiddleware)

local Rodux = {
	Store = require(script.Store),
	createReducer = require(script.createReducer),
	combineReducers = require(script.combineReducers),
	makeActionCreator = require(script.makeActionCreator),
	loggerMiddleware = loggerMiddleware.middleware,
	thunkMiddleware = thunkMiddleware,
}

table.freeze(Rodux)

return Rodux
