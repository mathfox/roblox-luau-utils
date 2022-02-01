local getAdorneeAlignedSizeFast = require(script.Parent.getAdorneeAlignedSizeFast)

local function getAdorneeAlignedSize(adornee: Instance): Vector3?
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeAlignedSize' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'getAdorneeAlignedSize' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	end

	return getAdorneeAlignedSizeFast(adornee)
end

return getAdorneeAlignedSize
