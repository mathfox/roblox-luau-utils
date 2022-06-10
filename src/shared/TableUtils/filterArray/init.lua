local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function filterArray(arr: Array<any>, predicate: (any, number, Array<any>) -> boolean): Array<any>
	local new = table.create(#arr)

	for index, value in arr do
		if predicate(value, index, arr) then
			table.insert(new, value)
		end
	end

	return new
end

return filterArray
