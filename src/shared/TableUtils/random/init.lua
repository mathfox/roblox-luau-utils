local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function random<V>(arr: Array<V>, rngOverride: Random?)
	local length = #arr
	return if length == 1 then arr[1] else arr[(rngOverride or Random.new()):NextInteger(1, length)]
end

return random
