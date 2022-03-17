local Types = require(script.Parent.Types)

local function extend(tbl: Types.GenericTable, extension: Types.GenericTable): Types.GenericTable
	return table.move(extension, 1, #extension, #tbl + 1, table.clone(tbl))
end

return extend
