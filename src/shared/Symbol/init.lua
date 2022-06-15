--!strict

--[[
	A 'Symbol' is an opaque marker type that can be used to signify unique
	statuses. Symbols have the type 'table', but when printed to the console,
	the name of the symbol is shown.

   reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol
]]

local Types = require(script.Parent.Types)

export type Symbol = Types.Symbol

local SymbolConstructor = table.freeze(setmetatable(
	{},
	table.freeze({
		__call = function(_, name: string?)
			return (
				if name
					then table.freeze(setmetatable(
						{},
						table.freeze({
							__tostring = function()
								return "Symbol(" .. name .. ")"
							end,
						})
					))
					else table.freeze(setmetatable(
						{},
						table.freeze({
							__tostring = function()
								return "Symbol()"
							end,
						})
					))
			) :: Symbol
		end,
	})
))

type SymbolConstructor = typeof(SymbolConstructor)

return SymbolConstructor :: SymbolConstructor
