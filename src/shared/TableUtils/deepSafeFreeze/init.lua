local safeFreeze = require(script.Parent.safeFreeze)

local function deepSafeFreeze(tbl: { [any]: any })
	safeFreeze(tbl)

	for _, v in pairs(tbl) do
		if type(v) == "table" then
			deepSafeFreeze(v)
		end
	end
end

return deepSafeFreeze
