local getAdorneeBasePartPositionFast = require(script.Parent.getAdorneeBasePartPositionFast)

local function getAdorneeBasePartPosition(adornee: Instance)
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeBasePartPosition' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(
			("invalid argument #1 to 'getAdorneeBasePartPosition' (Instance expected, got %s)"):format(typeof(adornee)),
			2
		)
	end

	return getAdorneeBasePartPositionFast(adornee)
end

return getAdorneeBasePartPosition
