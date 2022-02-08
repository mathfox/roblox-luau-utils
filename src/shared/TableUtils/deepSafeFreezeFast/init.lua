local Types = require(script.Parent.Types)

local function deepSafeFreezeFast(tbl: Types.GenericTable)
	if not table.isfrozen(tbl) then
		table.freeze(tbl)
	end

	for _, v in pairs(tbl) do
		if type(v) == "table" then
			deepSafeFreezeFast(v)
		end
	end
end

return deepSafeFreezeFast
