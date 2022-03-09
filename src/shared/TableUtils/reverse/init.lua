local Types = require(script.Parent.Types)

local function reverse(tbl: Types.GenericTable)
	local n = #tbl
	local new: Types.GenericTable = table.create(n)

	for i = 1, n do
		new[i] = tbl[n - i + 1]
	end

	return new
end

return reverse
