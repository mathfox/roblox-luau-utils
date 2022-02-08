local safeFreezeFast = require(script.Parent.safeFreezeFast)
local Types = require(script.Parent.Types)

local function safeFreeze(tbl: Types.GenericTable)
	if tbl == nil then
		error("missing argument #1 to 'safeFreeze' (table expected)", 2)
	elseif type(tbl) ~= "table" then
		error(("invalid argument #1 to 'safeFreeze' (table expected, got %s)"):format(typeof(tbl)), 2)
	end

	safeFreezeFast(tbl)
end

return safeFreeze
