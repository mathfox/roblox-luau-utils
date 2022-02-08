local Types = require(script.Parent.Types)

local function safeFreezeFast(tbl: Types.GenericTable)
	if not table.isfrozen(tbl) then
		table.freeze(tbl)
	end
end

return safeFreezeFast
