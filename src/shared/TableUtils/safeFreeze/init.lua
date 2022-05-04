local Types = require(script.Parent.Parent.Types)

type Record<K, V> = Types.Record<K, V>

local function safeFreeze(tbl: Record<any, any>)
	if not table.isfrozen(tbl) then
		table.freeze(tbl)
	end
end

return safeFreeze
