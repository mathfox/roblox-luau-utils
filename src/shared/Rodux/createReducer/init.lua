local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>
type Reducer = Types.RoduxReducer
type Action = Types.RoduxAction

local function createReducer<State>(initialState: State, handlers: Record<any, Reducer>, ...): Reducer<State>
	return function(state: any, action: Action)
		if state == nil then
			state = initialState
		end

		local handler = handlers[action.type]

		if handler then
			return handler(state, action)
		end

		return state
	end
end

return createReducer
