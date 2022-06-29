--[[
	Exposes a single instance of a configuration as Roact's GlobalConfig.
]]

local Config = require(script.Parent.Config)

local GlobalConfig = Config.new()

return GlobalConfig
