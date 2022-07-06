--[[
	This is a simple signal implementation that has a dead-simple API.

		local signal = createSignal()

		local disconnect = signal:subscribe(function(foo)
			print("Cool foo:", foo)
		end)

		signal:fire("something")

		disconnect()
]]

local config = require(script.Parent.GlobalConfig).get()

local function createSignal()
	local connections = {}
	local suspendedConnections = {}
	local firing = false

	local function subscribe(_, callback)
		if config.internalTypeChecks then
			if typeof(callback) ~= "function" then
				error("Can only subscribe to signals with a function.", 2)
			end
		end

		local connection = {
			callback = callback,
			disconnected = false,
		}

		-- If the callback is already registered, don't add to the suspendedConnection. Otherwise, this will disable
		-- the existing one.
		if firing and not connections[callback] then
			suspendedConnections[callback] = connection
		end

		connections[callback] = connection

		local function disconnect()
			if connection.disconnected then
				error("Listeners can only be disconnected once.", 2)
			end

			connection.disconnected = true
			connections[callback] = nil
			suspendedConnections[callback] = nil
		end

		return disconnect
	end

	local function fire(_, ...)
		firing = true
		for callback, connection in connections do
			if not connection.disconnected and not suspendedConnections[callback] then
				callback(...)
			end
		end

		firing = false

		for callback, _ in suspendedConnections do
			suspendedConnections[callback] = nil
		end
	end

	return {
		subscribe = subscribe,
		fire = fire,
	}
end

return createSignal
