local Types = require(script.Parent.Types)

local function mapFast(
	tbl: Types.GenericTable,
	func: (v: any, k: any, tbl: Types.GenericTable) -> any
): Types.GenericTable
	local new = table.create(#tbl)
	for k, v in pairs(tbl) do
		new[k] = func(v, k, tbl)
	end
	return new
end

return mapFast
