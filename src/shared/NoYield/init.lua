--[[
	Calls a function and throws an error if it attempts to yield.

	Pass any number of arguments to the function after the callback.

	This function supports multiple return; all results returned from the
	given function will be returned.
]]

local function resultHandler(message: string, co: thread, ok: boolean, ...)
	if not ok then
		error(debug.traceback(co, (...)), 2)
	end

	if coroutine.status(co) ~= "dead" then
		error(debug.traceback(co, message), 2)
	end

	return ...
end

local function NoYield(message: string, callback, ...)
	local co = coroutine.create(callback)

	return resultHandler(message, co, coroutine.resume(co, ...))
end

return NoYield
