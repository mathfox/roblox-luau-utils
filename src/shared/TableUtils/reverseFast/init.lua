local Types = require(script.Parent.Types)

local function reverseFast(tbl: Types.GenericTable): Types.GenericTable
	local n = #tbl
	local new = table.create(n)
	for i = 1, n do
		new[i] = tbl[n - i + 1]
	end
	return new
end

return reverseFast
