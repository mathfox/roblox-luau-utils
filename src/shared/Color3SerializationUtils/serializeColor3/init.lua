local serializeColor3Fast = require(script.Parent.serializeColor3Fast)
local Types = require(script.Parent.Types)

local function serializeColor3(color3: Color3): Types.SerializedColor3
	if color3 == nil then
		error("missing argument #1 to 'serializeColor3' (Color3 expected)", 2)
	elseif typeof(color3) ~= "Color3" then
		error(("invalid argument #1 to 'serializeColor3' (Color3 expected, got %s)"):format(typeof(color3)), 2)
	end

	return serializeColor3Fast(color3)
end

return serializeColor3
