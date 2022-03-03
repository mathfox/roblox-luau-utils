local getAdorneeBasePartCFrameFast = require(script.Parent.getAdorneeBasePartCFrameFast)

local function getAdorneeBasePartCFrame(adornee: Instance)
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeBasePartCFrame' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(
			("invalid argument #1 to 'getAdorneeBasePartCFrame' (Instance expected, got %s)"):format(typeof(adornee)),
			2
		)
	end

	return getAdorneeBasePartCFrameFast(adornee)
end

return getAdorneeBasePartCFrame
