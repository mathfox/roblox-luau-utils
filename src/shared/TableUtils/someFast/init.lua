local Types = require(script.Parent.Types)

local function someFast(
	tbl: Types.GenericTable,
	predicate: (v: any, k: any, tbl: Types.GenericTable) -> boolean
): boolean
	for k, v in pairs(tbl) do
		if predicate(v, k, tbl) then
			return true
		end
	end

	return false
end

return someFast
