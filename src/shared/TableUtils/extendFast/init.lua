local copyShallowFast = require(script.Parent.copyShallowFast)
local Types = require(script.Parent.Types)

local function extendFast(tbl: Types.GenericTable, extension: Types.GenericTable): Types.GenericTable
	return table.move(extension, 1, #extension, #tbl + 1, copyShallowFast(tbl))
end

return extendFast
