local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function everyArray<V>(source: Array<V>, predicate: (V, number, Array<V>) -> boolean)
	for index, value in ipairs(source) do
		if not predicate(value, index, source) then
			return false
		end
	end
	return true
end

return everyArray
