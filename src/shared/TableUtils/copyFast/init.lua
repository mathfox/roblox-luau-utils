local Types = require(script.Parent.Types)

local function copyFast(tbl: Types.GenericTable)
	local new: Types.GenericTable = table.create(#tbl)

	for k, v in pairs(tbl) do
		new[k] = if type(v) == "table" then copyFast(v) else v
	end

	return new
end

return copyFast
