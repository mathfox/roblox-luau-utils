local loggerMiddleware = require(script.loggerMiddleware)

local Rodux = {
	createStore = require(script.Store).new,
	createReducer = require(script.createReducer),
	combineReducers = require(script.combineReducers),
	makeActionCreator = require(script.makeActionCreator),
	loggerMiddleware = loggerMiddleware.middleware,
	thunkMiddleware = require(script.thunkMiddleware),
}

table.freeze(Rodux)

return Rodux
