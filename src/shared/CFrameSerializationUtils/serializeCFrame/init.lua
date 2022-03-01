local serializeCFrameFast = require(script.Parent.serializeCFrameFast)

local function serializeCFrame(cframe: CFrame)
	if cframe == nil then
		error("missing argument #1 to 'serializeCFrame' (CFrame expected)", 2)
	elseif typeof(cframe) ~= "CFrame" then
		error(("invalid argument #1 to 'serializeCFrame' (CFrame expected, got %s)"):format(typeof(cframe)), 2)
	end

	return serializeCFrameFast(cframe)
end

return serializeCFrame
