--[[
	A limited, simple implementation of a Signal.

	Handlers are fired in order, and (dis)connections are properly handled when
	executing an event.
]]

local config = require(script.Parent.GlobalConfig).get()

local function immutableAppend(list, ...)
	local new = {}
	local len = #list

	for key = 1, len do
		new[key] = list[key]
	end

	for i = 1, select("#", ...) do
		new[len + i] = select(i, ...)
	end

	return new
end

local function immutableRemoveValue(list, removeValue)
	local new = {}

	for i = 1, #list do
		if list[i] ~= removeValue then
			table.insert(new, list[i])
		end
	end

	return new
end

local Signal = {}
Signal.__index = Signal

function Signal:connect(callback)
	if config.typeChecks then
		if type(callback) ~= "function" then
			error("invalid #1 argument, expected a function", 2)
		end
	end

	if self._store and self._store._isDispatching then
		error(
			"You may not call store.changed:connect() while the reducer is executing. "
				.. "If you would like to be notified after the store has been updated, subscribe from a "
				.. "component and invoke store:getState() in the callback to access the latest state. "
		)
	end

	local listener = {
		callback = callback,
		disconnected = false,
		connectTraceback = debug.traceback(nil, 2),
		disconnectTraceback = nil,
	}

	self._listeners = immutableAppend(self._listeners, listener)

	local function disconnect()
		if listener.disconnected then
			error(("Listener connected at: \n%s\n" .. "was already disconnected at: \n%s\n"):format(tostring(listener.connectTraceback), tostring(listener.disconnectTraceback)))
		end

		if self._store and self._store._isDispatching then
			error("You may not unsubscribe from a store listener while the reducer is executing.")
		end

		listener.disconnected = true
		listener.disconnectTraceback = debug.traceback()
		self._listeners = immutableRemoveValue(self._listeners, listener)
	end

	return {
		disconnect = disconnect,
	}
end

function Signal:fire(...)
	for _, listener in self._listeners do
		if not listener.disconnected then
			local co = coroutine.create(listener.callback)
			local ok, message = coroutine.resume(co, ...)
			if not ok then
				error(message, 2)
			elseif coroutine.status(co) ~= "dead" then
				-- TODO: proper debug traceback to the place where connection was created
				error(('Attempted to yield inside a "changed" connection which was connected at:\n%s'):format(listener.connectTraceback), 2)
			end
		end
	end
end

local SignalExport = {}

function SignalExport.new(store)
	return setmetatable({
		_listeners = {},
		_store = store,
	}, Signal)
end

table.freeze(SignalExport)

return SignalExport
