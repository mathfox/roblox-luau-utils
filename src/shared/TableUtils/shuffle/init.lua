local copyShallow = require(script.Parent.copyShallow)
local Types = require(script.Parent.Types)

local function shuffle(tbl: Types.GenericTable, rngOverride: Random?)
	local new = copyShallow(tbl)
	local random = rngOverride or Random.new()

	for i = #tbl, 2, -1 do
		local j = random:NextInteger(1, i)
		new[i], new[j] = new[j], new[i]
	end

	return new
end

return shuffle
