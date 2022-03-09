local Types = require(script.Parent.Types)

local function length(tbl: Types.GenericTable)
	local l = 0

	for _ in pairs(tbl) do
		l += 1
	end

	return l
end

return length
