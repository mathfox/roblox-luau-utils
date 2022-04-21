local None = require(script.Parent.Parent.None)

--[[
	Merges values from zero or more tables onto a target table.
   If a value is set to None, it will instead be removed from the table.
]]
local function assign<K, V>(target: { [K]: V }, ...: { [K]: V }): { [K]: V }
	for index = 1, select("#", ...) do
		local source = select(index, ...)

		if source then
			for key, value in pairs(source) do
				target[key] = if value == None then nil else value
			end
		end
	end

	return target
end

return assign
