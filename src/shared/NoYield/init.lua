--[[
	Calls a function and throws an error if it attempts to yield.

	Pass any number of arguments to the function after the callback.

	This function supports multiple return; all results returned from the
	given function will be returned.
]]

local function outputHelper(...)
	local length = select("#", ...)
	local tbl: Array<string> = table.create(length)

	for index = 1, length do
		local value = select(index, ...)
		table.insert(tbl, ('"%s": %s'):format(tostring(value), typeof(value)))
	end

	return table.concat(tbl, ", ")
end

local function resultHandler<T...>(message: string, co: thread, ok: boolean, ...: T...)
	if not ok then
		error(debug.traceback(co, (...)), 2)
	elseif coroutine.status(co) ~= "dead" then
		error(debug.traceback(co, message), 2)
	end

	return ...
end

-- provide nil in case message is not yet specified
local function NoYield<T...>(messageOrNil: string?, callback: (T...) -> ...any, ...: T...)
	if type(messageOrNil) ~= "string" and messageOrNil ~= nil then
		error(('"messageOrNil" (#1 argument) must be either a string or nil, got (%s) instead'):format(outputHelper(messageOrNil)), 2)
	elseif messageOrNil == "" then
		error('"messageOrNil" (#1 argument) must be either a non-empty string or nil, got an empty string', 2)
	elseif type(callback) ~= "function" then
		error(('"callback" (#2 argument) must be a function, got (%s) instead'):format(outputHelper(callback)), 2)
	end

	local co = coroutine.create(callback)

	return resultHandler(messageOrNil or 'provided "callback" (#2 argument) function attempted to yield', co, coroutine.resume(co, ...))
end

return NoYield
