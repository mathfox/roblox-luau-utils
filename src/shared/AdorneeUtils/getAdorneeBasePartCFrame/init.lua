local getAdorneeBasePart = require(script.Parent.getAdorneeBasePart)

local function getAdorneeBasePartCFrame(adornee: Instance)
	local part = getAdorneeBasePart(adornee)
	return if part then part.CFrame else nil
end

return getAdorneeBasePartCFrame
