--[[
	A 'Symbol' is an opaque marker type that can be used to signify unique
	statuses. Symbols have the type 'userdata', but when printed to the console,
	the name of the symbol is shown.
]]
local Symbol = {
	named = require(script.named),
	unnamed = require(script.unnamed),
}

return Symbol
