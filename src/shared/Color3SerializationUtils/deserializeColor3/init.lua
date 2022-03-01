local deserializeColor3Fast = require(script.Parent.deserializeColor3Fast)
local Types = require(script.Parent.Types)

local function deserializeColor3(serializedColor3: Types.SerializedColor3): Color3
	if serializedColor3 == nil then
		error("missing argument #1 to 'deserializeColor3' (table expected)", 2)
	elseif type(serializedColor3) ~= "table" then
		error(
			("invalid argument #1 to 'deserializeColor3' (table expected, got %s)"):format(typeof(serializedColor3)),
			2
		)
	end

	return deserializeColor3Fast(serializedColor3)
end

return deserializeColor3
