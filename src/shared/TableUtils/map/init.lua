local Types = require(script.Parent.Types)

local function map(tbl: Types.GenericTable, func: (v: any, k: any, tbl: Types.GenericTable) -> any)
	local new: Types.GenericTable = table.create(#tbl)

	for k, v in pairs(tbl) do
		new[k] = func(v, k, tbl)
	end

	return new
end

return map
