local Types = require(script.Parent.Types)

local function filterFast(tbl: Types.GenericTable, predicate: (v: any, k: any, tbl: Types.GenericTable) -> boolean)
	local new: Types.GenericTable = table.create(#tbl)

	if #tbl > 0 then
		for i, v in ipairs(tbl) do
			if predicate(v, i, tbl) then
				table.insert(new, v)
			end
		end
	else
		for k, v in pairs(tbl) do
			if predicate(v, k, tbl) then
				new[k] = v
			end
		end
	end

	return new
end

return filterFast
