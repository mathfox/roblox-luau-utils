local Result = require(script.Parent.Result)
local Option = require(script.Parent.Option)
local Types = require(script.Parent.Types)

type Result<T, E> = Types.Result<T, E>
type Option<T> = Types.Option<T>
type MatchableObject = Result<any, any> | Option<any>

local function match(object: MatchableObject)
	if Result.is(object) then
		local runningThread = coroutine.running()
		local wasMatchResultCalled = false

		local function matchResult(matches: { Ok: (any) -> (), Err: (any) -> () })
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
	elseif getmetatable(object).__index == Option._option then
		local runningThread = coroutine.running()
		local wasMatchOptionCalled = false

		local function matchOption(matches: { Some: (any) -> (), None: () -> () })
			if wasMatchOptionCalled then
				error("match function should only be called once", 2)
			end
			wasMatchOptionCalled = true

			if type(matches.Some) ~= "function" then
				error("pattern Some(_) not covered", 2)
			elseif type(matches.None) ~= "function" then
				error("pattern None not covered", 2)
			end

			if getmetatable(object) == Result._some then
				matches.Some(object._v)
			else
				matches.None()
			end
		end

		task.defer(function()
			if not wasMatchOptionCalled then
				coroutine.close(runningThread)
				error("match function must be called instantly", 2)
			end
		end)

		return matchOption
	else
		error(("cannot match (%s) of type (%s)"):format(tostring(object), typeof(object)), 2)
	end
end

return match
