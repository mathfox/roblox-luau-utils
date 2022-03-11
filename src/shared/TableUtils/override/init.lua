local copyShallow = require(script.Parent.copyShallow)
local Types = require(script.Parent.Types)

local function override(tbl: Types.GenericTable, overridingTbl: Types.GenericTable)
	local new = copyShallow(tbl)

	for k, v in pairs(overridingTbl) do
		new[k] = if type(v) == "table"
			then if type(new[k]) == "table" then override(new[k], v) else copyShallow(v)
			else v
	end

	return new
end

return override
