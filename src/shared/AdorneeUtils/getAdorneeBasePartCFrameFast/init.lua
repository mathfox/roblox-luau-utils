local getAdorneeBasePartFast = require(script.Parent.getAdorneeBasePartFast)

local function getAdorneeBasePartCFrameFast(adornee: Instance): CFrame?
	local part: BasePart? = getAdorneeBasePartFast(adornee)

	return if part then part.CFrame else nil
end

return getAdorneeBasePartCFrameFast
