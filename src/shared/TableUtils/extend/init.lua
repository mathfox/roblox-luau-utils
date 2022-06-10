local Types = require(script.Parent.Parent.Types)

type Array<T> = Types.Array<T>

local function extend(target: Array<any>, ...: Array<any>?)
	for index = 1, select("#", ...) do
		local source = select(index, ...)
		if source ~= nil then
			table.move(source, 1, #source, #target + 1, target)
		end
	end

	return target
end

return extend
