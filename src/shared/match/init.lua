local Result = require(script.Parent.Result)

local function match(object)
	if getmetatable(object).__index == Result._result then
		local runningThread = coroutine.running()
		local wasMatchResultCalled = false

		local function matchResult<T, E>(matches: { Ok: (T) -> (), Err: (E) -> () })
			if wasMatchResultCalled then
				error("match function should only be called once", 2)
			end
			wasMatchResultCalled = true

			if type(matches.Ok) ~= "function" then
				error("pattern Ok(_) not covered", 2)
			elseif type(matches.Err) ~= "function" then
				error("pattern Err(_) not covered", 2)
			end

			if getmetatable(object) == Result._ok then
				matches.Ok(object._v)
			else
				matches.Err(object._v)
			end
		end

		task.defer(function()
			if not wasMatchResultCalled then
				coroutine.close(runningThread)
				error("match function must be called instantly", 2)
			end
		end)

		return matchResult
	else
		error(("cannot match (%s) of type (%s)"):format(tostring(object), typeof(object)), 2)
	end
end

return match
