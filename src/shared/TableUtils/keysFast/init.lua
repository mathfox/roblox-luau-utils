local Types = require(script.Parent.Types)

local function keysFast(tbl: Types.GenericTable): Types.GenericTable
	local new = table.create(#tbl)
	for k in pairs(tbl) do
		table.insert(new, k)
	end
	return new
end

return keysFast
