--[[
	A 'Symbol' is an opaque marker type that can be used to signify unique
	statuses. Symbols have the type 'userdata', but when printed to the console,
	the name of the symbol is shown.
]]

local Types = require(script.Parent.Types)

type Symbol = Types.Symbol

local Symbol = {}

function Symbol.named(name: string): Symbol
	local self = newproxy(true)

	getmetatable(self).__tostring = function()
		return "Symbol<" .. name .. ">"
	end

	return self
end

function Symbol.unnamed(): Symbol
	local self = newproxy(true)

	getmetatable(self).__tostring = function()
		return "Symbol<_>"
	end

	return self
end

return Symbol :: {
	named: (name: string) -> Symbol,
	unnamed: () -> Symbol,
}
