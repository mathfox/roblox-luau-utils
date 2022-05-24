-- modified version of https://github.com/Roblox/roact-rodux

local RoactRodux = {
	StoreProvider = require(script.StoreProvider),
	StoreContext = require(script.StoreContext),
	connect = require(script.connect),
}

table.freeze(RoactRodux)

return RoactRodux
