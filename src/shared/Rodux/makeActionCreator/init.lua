--[[
	A helper function to define a Rodux action creator with an associated name.
]]

local Types = require(script.Parent.Parent.Types)

type Fn<A..., R...> = Types.Fn<A..., R...>
type Record = Types.Record<K, V>

local function outputHelper(...)
	local length = select("#", ...)
	local tbl: Array<string> = table.create(length)

	for index = 1, length do
		local value = select(index, ...)
		table.insert(tbl, ('"%s": %s'):format(tostring(value), typeof(value)))
	end

	return table.concat(tbl, ", ")
end

local function makeActionCreator<T...>(name: string, fn: Fn<T..., Record<any, any>>, ...: T...)
	if type(name) ~= "string" then
		error(('"name" (#1 argument) must be a string which should be a name for the action creator, got (%s) instead'):format(outputHelper(name)), 2)
	elseif type(fn) ~= "function" then
		error(('"fn" (#2 argument) must be function which is responsible for actions create, got (%s) instead'):format(outputHelper(fn)), 2)
	elseif select("#", ...) > 0 then
		error(('"makeActionCreator" function expects exactly two arguments (string, function) but got (%s) as well'):format(outputHelper(...)), 2)
	end

   -- stylua: ignore
	return table.freeze(setmetatable({ name = name }, table.freeze({
		__call = function(_, ...: T...)
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
