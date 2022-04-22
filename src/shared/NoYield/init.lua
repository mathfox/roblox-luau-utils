--[[
	Calls a function and throws an error if it attempts to yield.

	Pass any number of arguments to the function after the callback.

	This function supports multiple return; all results returned from the
	given function will be returned.
]]

local function resultHandler<T...>(message: string, co: thread, ok: boolean, ...: T...)
	if not ok then
		error(debug.traceback(co, (...)), 2)
	elseif coroutine.status(co) ~= "dead" then
		error(debug.traceback(co, message), 2)
	end

	return ...
end

local function NoYield<T...>(message: string, callback: (T...) -> ...any, ...: T...)
	if type(message) ~= "string" then
		error(
			('"message" (#1 argument) must be a string, got ("%s": %s) instead'):format(
				tostring(message),
				typeof(message)
			),
			2
		)
	elseif message == "" then
		error('"message" (#1 argument) must be a non-empty string', 2)
	elseif type(callback) ~= "function" then
		error(
			('"callback" (#2 argument) must be a function, got ("%s": %s) instead'):format(
				tostring(callback),
				typeof(callback)
			),
			2
		)
	end

	local co = coroutine.create(callback)

	return resultHandler(message, co, coroutine.resume(co, ...))
end

return NoYield
