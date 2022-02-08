local copyShallowFast = require(script.Parent.copyShallowFast)
local Types = require(script.Parent.Types)

local function shuffleFast(tbl: Types.GenericTable, rngOverride: Random?): Types.GenericTable
	local new = copyShallowFast(tbl)
	local random = rngOverride or Random.new()
	for i = #tbl, 2, -1 do
		local j = random:NextInteger(1, i)
		new[i], new[j] = new[j], new[i]
	end
	return new
end

return shuffleFast
