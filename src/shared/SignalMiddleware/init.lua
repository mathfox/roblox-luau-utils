local Signal = require(script.Parent.Signal)

local function fireOnDispatch(signal)
	if not Signal.is(signal) then
		error("#1 argument must be a Signal!", 2)
	end

	return function(nextDispatch)
		return function(action)
			if signal.Destroy then
				signal:Fire(action)
			else
				warn(".fireOnDispatch - Signal is destroyed, but middleware is still connected")
			end

			nextDispatch(action)
		end
	end
end

local SignalMiddleware = {
	fireOnDispatch = fireOnDispatch,
	FireOnDispatch = fireOnDispatch,
}

return SignalMiddleware
