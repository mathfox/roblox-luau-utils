local getAdorneeBasePartFast = require(script.Parent.getAdorneeBasePartFast)

local function getAdorneeBasePartCFrameFast(adornee: Instance)
	local part = getAdorneeBasePartFast(adornee)
	return if part then part.CFrame else nil
end

return getAdorneeBasePartCFrameFast
