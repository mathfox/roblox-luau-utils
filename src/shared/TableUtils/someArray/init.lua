local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function someArray<V>(arr: Array<V>, predicate: (V, number, Array<V>) -> boolean)
	for index, value in ipairs(arr) do
		if predicate(value, index, arr) then
			return true
		end
	end
	return false
end

return someArray
