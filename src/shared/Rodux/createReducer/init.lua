local Types = require(script.Parent.Parent.Types)

type EnumeratorItem<V> = Types.EnumeratorItem<V>
type RoduxStoreState = Types.RoduxStoreState
type Record<K, V> = Types.Record<K, V>
type RoduxReducer = Types.RoduxReducer
type RoduxAction = Types.RoduxAction

local function createReducer(
	initialState: RoduxStoreState,
	handlers: Record<string | EnumeratorItem<any>, RoduxReducer>,
	...
): RoduxReducer
	if initialState == nil then
		error('"initialState" (#1 argument) cannot be nil, you should use None instead!', 2)
	elseif type(handlers) ~= "table" then
	end

	local function reducer(state: RoduxStoreState, action: RoduxAction)
		if state == nil then
			state = initialState
		end

		local handler = handlers[action.type]

		if handler then
			return handler(state, action)
		end

		return state
	end

	return reducer
end

return createReducer
