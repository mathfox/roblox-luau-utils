--[[
	A 'Symbol' is an opaque marker type that can be used to signify unique
	statuses. Symbols have the type 'userdata', but when printed to the console,
	the name of the symbol is shown.
]]

local Types = require(script.Parent.Types)

export type Symbol = Types.Symbol
type Array<T> = Types.Array<T>

local function outputHelper(...)
	local tbl: Array<string> = {}

	for index = 1, select("#", ...) do
		local value = select(index, ...)
		table.insert(tbl, ('"%s": %s'):format(tostring(value), typeof(value)))
	end

	return table.concat(tbl, ", ")
end

local SymbolExport = {
	named = function(name: string, ...): Symbol
		if type(name) ~= "string" then
			error(('"name" (#1 argument) must be a string, got ("%s": %s) instead'):format(tostring(name), typeof(name)), 2)
		elseif name == "" then
			error('"name" (#1 argument) must be a non-empty string, maybe you should try to use Symbol.unnamed instead?', 2)
		elseif select("#", ...) > 0 then
			error(('"named" function expects exactly one argument: (string), but got (%s) as well'):format(outputHelper(...)), 2)
		end

		local self = newproxy(true)
		getmetatable(self).__tostring = function()
			return "Symbol<" .. name .. ">"
		end
		return self
	end,

	unnamed = function(...): Symbol
		if select("#", ...) > 0 then
			error(('"unnamed" function expects no values, got (%s) instead'):format(outputHelper(...)), 2)
		end

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
