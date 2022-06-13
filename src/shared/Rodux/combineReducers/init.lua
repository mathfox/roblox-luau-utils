local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>
type Reducer = Types.RoduxReducer
type Action = Types.RoduxAction

-- Create a composite reducer from a map of keys and sub-reducers.
local function combineReducers(map: Record<any, Reducer>)
	return function(state, action: Action)
		if state == nil then
			state = {}
		end

		local newState = {}

		for key, reducer in pairs(map) do
			-- Each reducer gets its own state, not the entire state table
			newState[key] = reducer(state[key], action)
		end

		return newState
	end
end

return combineReducers
