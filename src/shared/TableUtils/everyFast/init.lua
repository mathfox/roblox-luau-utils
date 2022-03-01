local Types = require(script.Parent.Types)

local function everyFast(tbl: Types.GenericTable, predicate: (v: any, k: any, tbl: Types.GenericTable) -> boolean)
	for k, v in pairs(tbl) do
		if not predicate(v, k, tbl) then
			return false
		end
	end

	return true
end

return everyFast
