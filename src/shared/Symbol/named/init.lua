local Types = require(script.Parent.Types)

local function named(name: string): Types.Symbol
	local self = newproxy(true)

	local wrappedName = ("Symbol(%s)"):format(name)

	getmetatable(self).__tostring = function()
		return wrappedName
	end

	return self
end

return named
