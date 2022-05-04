local Types = require(script.Parent.Parent.Types)

type EnumeratorItem<V> = Types.EnumeratorItem<V>
type RoduxStoreState = Types.RoduxStoreState
type RoduxReducer = Types.RoduxReducer
type Record<K, V> = Types.Record<K, V>
type RoduxAction = Types.RoduxAction

local function createReducer(initialState: RoduxStoreState, handlers: Record<string | EnumeratorItem<any>, RoduxReducer>, ...): RoduxReducer
	return function(state: RoduxStoreState, action: RoduxAction)
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
