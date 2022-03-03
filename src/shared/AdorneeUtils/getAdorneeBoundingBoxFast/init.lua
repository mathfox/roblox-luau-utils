local getAdorneeBasePartCFrameFast = require(script.Parent.getAdorneeBasePartCFrameFast)
local getAdorneeAlignedSizeFast = require(script.Parent.getAdorneeAlignedSizeFast)

local function getAdorneeBoundingBoxFast(adornee: Instance)
	if adornee:IsA("Model") then
		return adornee:GetBoundingBox()
	elseif adornee:IsA("Attachment") then
		return adornee.WorldCFrame, Vector3.zero
	else
		return getAdorneeBasePartCFrameFast(adornee), getAdorneeAlignedSizeFast(adornee)
	end
end

return getAdorneeBoundingBoxFast
