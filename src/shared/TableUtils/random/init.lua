local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function random<V>(arr: Array<V>, rngOverride: Random?)
	return arr[(rngOverride or Random.new()):NextInteger(1, #arr)]
end

return random
