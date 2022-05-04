local Types = require(script.Parent.Parent.Types)

type Array = Types.Array<T>

local function reverse<V>(arr: Array<V>): Array<V>
	local length = #arr
	local new = table.create(length)
	for index = 1, length do
		new[index] = arr[length - index + 1]
	end
	return new
end

return reverse
