--[[
	Create a composite reducer from a map of keys and sub-reducers.
]]
local function combineReducers(map)
	return function(state, action)
		local newState = {}

		for key, reducer in pairs(map) do
			-- Each reducer gets its own state, not the entire state table
			newState[key] = reducer(if state then state[key] else nil, action)
		end

		return newState
	end
end

return combineReducers
