local getAdorneeBasePartFast = require(script.Parent.getAdorneeBasePartFast)

local function getAdorneeBasePartPositionFast(adornee: Instance)
	local part = getAdorneeBasePartFast(adornee)
	return if part then part.Position else nil
end

return getAdorneeBasePartPositionFast
