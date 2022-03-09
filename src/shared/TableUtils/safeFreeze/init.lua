local Types = require(script.Parent.Types)

local function safeFreeze(tbl: Types.GenericTable)
	if not table.isfrozen(tbl) then
		table.freeze(tbl)
	end
end

return safeFreeze
