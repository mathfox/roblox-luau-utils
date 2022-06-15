--[[
	Calls a function and throws an error if it attempts to yield.

	Pass any number of arguments to the function after the callback.

	This function supports multiple return; all results returned from the
	given function will be returned.
]]

-- * important to note that NoYield will only return the tuple returned from the co thread
local function resultHandler<R...>(message: string, co: thread, ok: boolean, ...: R...)
	if not ok then
		error(debug.traceback(co, (...)), 2)
	elseif coroutine.status(co) ~= "dead" then
		error(debug.traceback(co, message), 2)
	end

	return ...
end

-- provide nil in case message is not yet specified
local function NoYield<T..., R...>(messageOrNil: string?, callback: (T...) -> R..., ...: T...)
	local co = coroutine.create(callback)

	return resultHandler(messageOrNil or 'provided "callback" (#2 argument) function attempted to yield', co, coroutine.resume(co, ...))
end

return NoYield
