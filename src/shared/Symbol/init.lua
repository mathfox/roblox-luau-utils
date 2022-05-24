--[[
	A 'Symbol' is an opaque marker type that can be used to signify unique
	statuses. Symbols have the type 'userdata', but when printed to the console,
	the name of the symbol is shown.

   reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol
]]

local Types = require(script.Parent.Types)

type Record<K, V> = Types.Record<K, V>
export type Symbol = Types.Symbol
type Array<T> = Types.Array<T>

local function outputHelper(...)
	local length = select("#", ...)
	local arr: Array<string> = table.create(length)

	for index = 1, length do
		local value = select(index, ...)
		table.insert(arr, ('"%s": %s'):format(tostring(value), typeof(value)))
	end

	return table.concat(arr, ", ")
end

-- an internal function used by both __call metamethod and named constructor function
local createNamed: (name: string) -> Symbol = nil

do
	-- the purpose of this block is to speed up the creation of named symbols with the same "name" value;
	-- the way this is achieved is that each time named symbol with a certain "name" gets created
	-- it's frozen metatable gets cached in a weak-value table, so further function calls
	-- will just use this metatable and as soon as there is no more references to any of the
	-- named symbols with a provided "name", that metatable gets gced and the next call will repeat
	-- the same procedure with a creation and caching again;

	type NamedSymbolMetatable = { __tostring: () -> string }

	-- there is no point for the late initialization of the table as there is no way to track
	-- the garbage collection of the table values which is requires for us to assign this variable to a nil
	-- when there is no more cached metatables left
	local namedSymbolMetatablesCache: Record<string, NamedSymbolMetatable> = setmetatable({}, { __mode = "v" })

	function createNamed(name: string)
		local cachedSymbolMetatable: NamedSymbolMetatable? = namedSymbolMetatablesCache[name]
		if cachedSymbolMetatable then
			return table.freeze(setmetatable({}, cachedSymbolMetatable)) :: Symbol
		end

		local newSymbolMetatable = {
			__tostring = function()
				return "Symbol(" .. name .. ")"
			end,
		}

		namedSymbolMetatablesCache[name] = newSymbolMetatable

		return table.freeze(setmetatable({}, newSymbolMetatable)) :: Symbol
	end
end

-- an internal function used by both __call metamethod and unnamed constructor function
local createUnnamed: () -> Symbol = nil

do
	-- the purpose of this block is to dynamically create and cache global table with a __tostring
	-- function that will be shared between all of the unnamed symbols, so if unnamed symbol never
	-- gets created we'll never create and cache that table;
	-- as a result unnamed symbols construction gets ~20% percent faster

	type UnnamedSymbolMetatable = { __tostring: () -> "Symbol()" }

	local cachedUnnamedSymbolMetatable: UnnamedSymbolMetatable? = nil

	function createUnnamed()
		if not cachedUnnamedSymbolMetatable then
			cachedUnnamedSymbolMetatable = {
				__tostring = function()
					return "Symbol<_>"
				end,
			}

			-- make sure further calls won't have to check if the table with a __tostring function
			-- was cached or not, so they will always assume it has been created and cached;
			createUnnamed = function()
				return table.freeze(setmetatable({}, cachedUnnamedSymbolMetatable :: UnnamedSymbolMetatable)) :: Symbol
			end
		end

		return table.freeze(setmetatable({}, cachedUnnamedSymbolMetatable :: UnnamedSymbolMetatable)) :: Symbol
	end
end

local SymbolExport = table.freeze(setmetatable(
	{
		named = function(name: string, ...)
			if type(name) ~= "string" then
				error(('"name" (#1 argument) must be a string, got (%s) instead'):format(outputHelper(name)), 2)
			elseif name == "" then
				error('"name" (#1 argument) must be a non-empty string, maybe you should try to use Symbol.unnamed function instead?', 2)
			elseif select("#", ...) > 0 then
				error(('"named" function expected exactly one argument of type (string), but got (%s) as well'):format(outputHelper(...)), 2)
			end

			return createNamed(name)
		end,

		unnamed = function(...)
			if select("#", ...) > 0 then
				error(('"unnamed" function expected no values, got (%s) instead'):format(outputHelper(...)), 2)
			end

			return createUnnamed()
		end,
	},
	table.freeze({
		__call = function(_, ...)
			local name, length = (...), select("#", ...)

			if type(name) == "string" then
				if (name :: string) == "" then
					error(
						"In case SymbolConstuctor receives the string as the first arguments, it must be a non-empty string, maybe you should try to use either a Symbol() or Symbol.unnamed function instead?",
						2
					)
				elseif length > 1 then
					error(
						("In case SymbolConstructor receives the string as the first argument, no extra arguments should be provided, but (%s) arguments were provided"):format(
							outputHelper(select(2, ...))
						),
						2
					)
				end

				return createNamed(name :: string)
			elseif length ~= 0 then
				error(("SymbolConstuctor expects either one string or no values, got (%s) instead"):format(outputHelper(...)), 2)
			end

			return createUnnamed()
		end,
	})
))

type SymbolConstructor = {
	named: (name: string) -> Symbol,
	unnamed: () -> Symbol,
} & (name: string?) -> Symbol

return SymbolExport :: SymbolConstructor
