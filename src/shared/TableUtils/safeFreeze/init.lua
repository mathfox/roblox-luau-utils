local Types = require(script.Parent.Parent.Types)

type Record<K, V = K> = Types.Record<K, V>

local function safeFreeze(tbl: Record<any>)
	if not table.isfrozen(tbl) then
		table.freeze(tbl)
	end
end

return safeFreeze
