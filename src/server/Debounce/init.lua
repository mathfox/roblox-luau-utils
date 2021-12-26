local Unite = require(game:GetService("ReplicatedStorage").Unite)

local TableUtils = require(Unite.SharedModules.TableUtils)

return TableUtils.assign(require(Unite.SharedModules.Debounce), {
	Player = require(script.PlayerDebounce),
})
