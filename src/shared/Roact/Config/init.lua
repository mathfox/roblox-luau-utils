--[[
	Exposes an interface to set global configuration values for Roact.

	Configuration can only occur once, and should only be done by an application
	using Roact, not a library.

	Any keys that aren't recognized will cause errors. Configuration is only
	intended for configuring Roact itself, not extensions or libraries.

	Configuration is expected to be set immediately after loading Roact. Setting
	configuration values after an application starts may produce unpredictable
	behavior.
]]

-- Every valid configuration value should be non-nil in this table.
local defaultConfig = {
	-- Enables asserts for internal Roact APIs. Useful for debugging Roact itself.
	internalTypeChecks = false,
	-- Enables stricter type asserts for Roact's public API.
	typeChecks = false,
	-- Enables storage of `debug.traceback()` values on elements for debugging.
	elementTracing = false,
	-- Enables validation of component props in stateful components.
	propValidation = false,
}

type ConfigTable<T = boolean> = {
	internalTypeChecks: boolean,
	typeChecks: boolean,
	elementTracing: boolean,
	propValidation: boolean,
}
type Config = {
	get: () -> ConfigTable,
	set: (configValues: ConfigTable<boolean?>) -> (),
	scoped: (configValues: ConfigTable<boolean?>, callback: () -> ()) -> (),
}

-- Build a list of valid configuration values up for debug messages.
local defaultConfigKeys = {}

for key in defaultConfig do
	table.insert(defaultConfigKeys, key)
end

local Config = {}

function Config:set(configValues)
	-- Validate values without changing any configuration.
	-- We only want to apply this configuration if it's valid!
	for key, value in configValues do
		if defaultConfig[key] == nil then
			error(("Invalid global configuration key %q (type %s). Valid configuration keys are: %s"):format(tostring(key), typeof(key), table.concat(defaultConfigKeys, ", ")), 3)
		elseif typeof(value) ~= "boolean" then
			error(("Invalid value %q (type %s) for global configuration key %q. Valid values are: true, false"):format(tostring(value), typeof(value), tostring(key)), 3)
		end

		self._currentConfig[key] = value
	end
end

function Config:get()
	return self._currentConfig
end

function Config:scoped(configValues, callback)
	local previousValues = {}

	for key, value in self._currentConfig do
		previousValues[key] = value
	end

	self.set(configValues)

	local success, result = pcall(callback)

	self.set(previousValues)

	if not success then
		error(result)
	end
end

local ConfigExport = {}

function ConfigExport.new(): Config
	local self = {}

	self._currentConfig = setmetatable({}, {
		__index = function(_, key)
			error(("Invalid global configuration key %q. Valid configuration keys are: %s"):format(tostring(key), table.concat(defaultConfigKeys, ", ")), 3)
		end,
	})

	-- We manually bind these methods here so that the Config's methods can be
	-- used without passing in self, since they eventually get exposed on the
	-- root Roact object.
	self.set = function(...)
		Config.set(self, ...)
	end

	self.get = function(...)
		return Config.get(self, ...)
	end

	self.scoped = function(...)
		Config.scoped(self, ...)
	end

	self.set(defaultConfig)

	return self
end

return ConfigExport
