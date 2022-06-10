local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function shuffle<V>(arr: Array<V>, rngOverride: Random?): Array<V>
	local new, random = table.clone(arr), if rngOverride then rngOverride :: Random else Random.new()

	for i = #arr, 2, -1 do
		local j = random:NextInteger(1, i)
		new[i], new[j] = new[j], new[i]
	end

	return new
end

return shuffle
