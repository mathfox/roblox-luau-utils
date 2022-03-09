local Types = require(script.Parent.Types)

local function find(tbl: Types.GenericTable, predicate: (v: any, k: any, tbl: Types.GenericTable) -> boolean)
	for k, v in pairs(tbl) do
		if predicate(v, k, tbl) then
			return v, k
		end
	end

	return nil, nil
end

return find
