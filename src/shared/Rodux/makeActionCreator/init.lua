-- A helper function to define a Rodux action creator with an associated name.

local Types = require(script.Parent.Parent.Types)

type ActionCreator<Type, Action, Args...> = Types.RoduxActionCreator<Type, Action, Args...>

local function makeActionCreator<Type, Action, Args...>(name: Type, fn: (Args...) -> Action): ActionCreator<Type, Action, Args...>
	return table.freeze(setmetatable(
		{ name = name },
		table.freeze({
			__call = function(_, ...: Args...): Action & { type: Type }
				local result = fn(...)

				result.type = name

				return result
			end,
		})
	))
end

return makeActionCreator
