local deserializeCFrameFast = require(script.Parent.deserializeCFrameFast)
local isSerializedCFrame = require(script.Parent.isSerializedCFrame)
local Types = require(script.Parent.Types)

local function deserializeCFrame(serializedCFrame: Types.SerializedCFrame)
	if serializedCFrame == nil then
		error("missing argument #1 to 'deserializeCFrame' (SerializedCFrame expected)", 2)
	elseif not isSerializedCFrame(serializedCFrame) then
		error(
			("invalid argument #1 to 'deserializeCFrame' (SerializedCFrame expected, got %s)"):format(
				typeof(serializedCFrame)
			),
			2
		)
	end

	return deserializeCFrameFast(serializedCFrame)
end

return deserializeCFrame
