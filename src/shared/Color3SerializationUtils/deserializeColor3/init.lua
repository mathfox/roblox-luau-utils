local deserializeColor3Fast = require(script.Parent.deserializeColor3Fast)
local isSerializedColor3 = require(script.Parent.isSerializedColor3)
local Types = require(script.Parent.Types)

local function deserializeColor3(serializedColor3: Types.SerializedColor3): Color3
	if serializedColor3 == nil then
		error("missing argument #1 to 'deserializeColor3' (SerializedColor3 expected)", 2)
	elseif not isSerializedColor3(serializedColor3) then
		error(
			("invalid argument #1 to 'deserializeColor3' (SerializedColor3 expected, got %s)"):format(
				typeof(serializedColor3)
			),
			2
		)
	end

	return deserializeColor3Fast(serializedColor3)
end

return deserializeColor3
