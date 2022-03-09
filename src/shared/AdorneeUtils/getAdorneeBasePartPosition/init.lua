local getAdorneeBasePart = require(script.Parent.getAdorneeBasePart)

local function getAdorneeBasePartPosition(adornee: Instance)
	local part = getAdorneeBasePart(adornee)
	return if part then part.Position else nil
end

return getAdorneeBasePartPosition
