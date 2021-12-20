local Unite = require(game:GetService("ReplicatedStorage").Unite)

local TableUtils = Unite.getSharedUtil("TableUtils")

return TableUtils.assign(Unite.getSharedUtil("Debounce"), {
	Player = require(script.PlayerDebounce),
})
