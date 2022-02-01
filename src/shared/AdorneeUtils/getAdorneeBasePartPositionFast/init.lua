local getAdorneeBasePartFast = require(script.Parent.getAdorneeBasePartFast)

local function getAdorneeBasePartPositionFast(adornee: Instance): Vector3?
	local part: BasePart? = getAdorneeBasePartFast(adornee)

	return if part then part.Position else nil
end

return getAdorneeBasePartPositionFast
