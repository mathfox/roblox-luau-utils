local copyShallowFast = require(script.Parent.copyShallowFast)
local Types = require(script.Parent.Types)

local function assignFast(tbl: Types.GenericTable, ...: Types.GenericTable): Types.GenericTable
	local new = copyShallowFast(tbl)

	for _, t in ipairs({ ... }) do
		for k, v in pairs(t) do
			new[k] = v
		end
	end

	return new
end

return assignFast
