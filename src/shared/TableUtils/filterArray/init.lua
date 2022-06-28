local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function filterArray<T>(arr: Array<T>, predicate: (T, number, Array<T>) -> boolean): Array<T>
	local new = table.create(#arr)

	for index, value in arr do
		if predicate(value, index, arr) then
			table.insert(new, value)
		end
	end

	return new
end

return filterArray
