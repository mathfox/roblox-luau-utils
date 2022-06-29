local Types = require(script.Parent.Parent.Types)

type Reducer<State, Action> = Types.RoduxReducer<State, Action>
type AnyAction = Types.RoduxAnyAction

local function createReducer<State>(initialState: State, handlers: { [any]: (State, AnyAction) -> State }): Reducer<State, AnyAction>
	return function(state: State?, action: AnyAction)
		local handler = handlers[action.type]
		return if handler then handler(if state == nil then initialState else state, action) else if state == nil then initialState else state
	end
end

return createReducer
