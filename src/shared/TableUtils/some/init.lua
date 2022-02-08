local someFast = require(script.Parent.someFast)
local Types = require(script.Parent.Types)

local function some(tbl: Types.GenericTable, predicate: (v: any, k: any, tbl: Types.GenericTable) -> boolean): boolean
	if tbl == nil then
		error("missing argument #1 to 'some' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'some' (table expected, got %s)"):format(typeof(tbl)), 2)
	elseif predicate == nil then
		error("missing argument #2 to 'some' (function expected)", 2)
	elseif type(predicate) ~= "function" then
		error(("invalid argument #2 to 'some' (function expected, got %s)"):format(typeof(predicate)), 2)
	end

	return someFast(tbl, predicate)
end

return some
