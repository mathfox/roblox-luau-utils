local Types = require(script.Parent.Types)

local function unnamed(): Types.Symbol
	local self = newproxy(true)

	getmetatable(self).__tostring = function()
		return "Symbol(Unnamed)"
	end

	return self
end

return unnamed
