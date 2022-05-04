local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function findArray<V>(arr: Array<V>, predicate: (V, number, Array<V>) -> boolean)
	for k, v in ipairs(arr) do
		if predicate(v, k, arr) then
			return v, k
		end
	end
	return nil, nil
end

return findArray
