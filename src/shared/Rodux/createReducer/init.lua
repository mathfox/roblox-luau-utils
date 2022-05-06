local Types = require(script.Parent.Parent.Types)

type EnumeratorItem<V> = Types.EnumeratorItem<V>
type StoreState = Types.RoduxStoreState
type Record<K, V> = Types.Record<K, V>
type Reducer = Types.RoduxReducer
type Action = Types.RoduxAction

local function createReducer(initialState: StoreState, handlers: Record<string | EnumeratorItem<any>, Reducer>, ...): Reducer
	return function(state: StoreState, action: Action)
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
