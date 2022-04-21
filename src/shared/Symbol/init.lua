--[[
	A 'Symbol' is an opaque marker type that can be used to signify unique
	statuses. Symbols have the type 'userdata', but when printed to the console,
	the name of the symbol is shown.
]]

local Types = require(script.Parent.Types)

export type Symbol = Types.Symbol

local SymbolExport = {
	named = function(name: string): Symbol
		local self = newproxy(true)
		getmetatable(self).__tostring = function()
			return "Symbol<" .. name .. ">"
		end
		return self
	end,

	unnamed = function(): Symbol
		local self = newproxy(true)
		getmetatable(self).__tostring = function()
			return "Symbol<_>"
		end
		return self
	end,
}

table.freeze(SymbolExport)

return SymbolExport :: {
	named: (name: string) -> Symbol,
	unnamed: () -> Symbol,
}
