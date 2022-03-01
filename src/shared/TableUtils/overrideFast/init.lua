local copyShallowFast = require(script.Parent.copyShallowFast)
local Types = require(script.Parent.Types)

local function overrideFast(tbl: Types.GenericTable, overridingTbl: Types.GenericTable)
	local new = copyShallowFast(tbl)

	for k, v in pairs(overridingTbl) do
		new[k] = if type(v) == "table" then if new[k] then overrideFast(new[k], v) else v else v
	end

	return new
end

return overrideFast
