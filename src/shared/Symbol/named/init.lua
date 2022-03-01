local namedFast = require(script.Parent.namedFast)
local Types = require(script.Parent.Types)

local function named(name: string): Types.Symbol
	if name == nil then
		error("missing argument #1 to 'named' (string expected)", 2)
	elseif type(named) ~= "string" then
		error(("invalid argument #1 to 'named' (string expected, got %s)"):format(typeof(named)), 2)
	end

	return namedFast(name)
end

return named
