local Types = require(script.Parent.Types)

local function copyShallowFast(tbl: Types.GenericTable)
	local new: Types.GenericTable = table.create(#tbl)

	if #tbl > 0 then
		table.move(tbl, 1, #tbl, 1, new)
	else
		for k, v in pairs(tbl) do
			new[k] = v
		end
	end

	return new
end

return copyShallowFast
