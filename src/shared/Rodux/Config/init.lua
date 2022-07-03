local defaultConfig = {
	-- Enables stricter type asserts for Rodux's public API.
	typeChecks = false,
}

type RoduxConfigTable = {
	typeChecks: boolean,
}
type PartialRoduxConfigTable = {
	typeChecks: boolean?,
}
type RoduxConfig = {
	set: (configValues: PartialRoduxConfigTable) -> (),
	get: () -> RoduxConfigTable,
}

-- Build a list of valid configuration values up for debug messages.
local defaultConfigKeys: { string } = {}

for key in defaultConfig do
	table.insert(defaultConfigKeys, key)
end

local Config = {}

function Config:set(configValues: PartialRoduxConfigTable)
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

function Config:get(): RoduxConfigTable
	return self._currentConfig
end

local ConfigExport = {}

function ConfigExport.new(): RoduxConfig
	local self = {
		_currentConfig = setmetatable({}, {
			__index = function(_, key)
				error(("Invalid global configuration key %q. Valid configuration keys are: %s"):format(tostring(key), table.concat(defaultConfigKeys, ", ")), 3)
			end,
		}),
	}

	-- We manually bind these methods here so that the Config's methods can be
	-- used without passing in self, since they eventually get exposed on the
	-- root Roact object.
	self.set = function(...)
		Config.set(self, ...)
	end

	self.get = function(...)
		return Config.get(self, ...)
	end

	self.set(defaultConfig)

	return self
end

table.freeze(ConfigExport)

return ConfigExport
