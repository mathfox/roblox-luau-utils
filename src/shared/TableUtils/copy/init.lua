local Types = require(script.Parent.Types)

local function copy(tbl: Types.GenericTable)
	local new: Types.GenericTable = table.create(#tbl)

	for k, v in pairs(tbl) do
		new[k] = if type(v) == "table" then copy(v) else v
	end

	return new
end

return copy
