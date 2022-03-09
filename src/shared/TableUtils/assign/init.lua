local copyShallow = require(script.Parent.copyShallow)
local Types = require(script.Parent.Types)

local function assign(tbl: Types.GenericTable, ...: Types.GenericTable)
	local new = copyShallow(tbl)

	for _, t in ipairs({ ... }) do
		for k, v in pairs(t) do
			new[k] = v
		end
	end

	return new
end

return assign
