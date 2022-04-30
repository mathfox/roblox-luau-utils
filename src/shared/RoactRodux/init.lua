local StoreProvider = require(script.StoreProvider)
local connect = require(script.connect)

local RoactRodux = {
	StoreProvider = StoreProvider,
	connect = connect,
}

table.freeze(RoactRodux)

return RoactRodux
