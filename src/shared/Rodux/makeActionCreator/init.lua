--[[
	A helper function to define a Rodux action creator with an associated name.
]]

local Types = require(script.Parent.Parent.Types)

export type ActionCreator<Type, Action, Args...> = Types.RoduxActionCreator<Type, Action, Args...>
type Array<T> = Types.Array<T>

local function outputHelper(...)
	local length = select("#", ...)
	local tbl: Array<string> = table.create(length)

	for index = 1, length do
		local value = select(index, ...)
		table.insert(tbl, ('"%s": %s'):format(tostring(value), typeof(value)))
	end

	return table.concat(tbl, ", ")
end

local function makeActionCreator<Type, Action, Args...>(name: Type, fn: Fn<(Args...), (Action)>, ...)
	if type(fn) ~= "function" then
		error(('"fn" (#2 argument) must be function which is responsible for actions create, got (%s) instead'):format(outputHelper(fn)), 2)
	elseif select("#", ...) > 0 then
		error(('"makeActionCreator" function expects exactly two arguments (any, function) but got (%s) as well'):format(outputHelper(...)), 2)
	end

   -- stylua: ignore
	return table.freeze(setmetatable({ name = name }, table.freeze({
		__call = function(_, ...: Args...)
			local result = fn(...)

			if type(result) ~= "table" then
				error(('"fn" (#2 argument) function must return a table, got (%s) instead'):format(outputHelper(fn)), 2)
			elseif result.type ~= nil then
				error(('An action table returned by the "fn" (#2 argument) function should not contain "type" field, got (%s) instead'):format(outputHelper(result.type)), 2)
			end

			result.type = name

			return result
		end,
	})))
end

return makeActionCreator
