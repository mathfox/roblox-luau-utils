local Types = require(script.Parent.Types)

local function lengthFast(tbl: Types.GenericTable)
	local length = 0

	for _ in pairs(tbl) do
		length += 1
	end

	return length
end

return lengthFast
