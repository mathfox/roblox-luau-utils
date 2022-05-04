local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function joinArray(...: Array<any>?): Array<any>
	local result = {}
	for index = 1, select("#", ...) do
		local source = select(index, ...)
		if source ~= nil then
			table.move(source, 1, #source, #result + 1, result)
		end
	end
	return result
end

return joinArray
