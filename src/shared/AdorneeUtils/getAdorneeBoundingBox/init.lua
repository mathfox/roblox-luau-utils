local getAdorneeBasePartCFrame = require(script.Parent.getAdorneeBasePartCFrame)
local getAdorneeAlignedSize = require(script.Parent.getAdorneeAlignedSize)

local function getAdorneeBoundingBox(adornee: Instance)
	if adornee:IsA("Model") then
		return adornee:GetBoundingBox()
	elseif adornee:IsA("Attachment") then
		return adornee.WorldCFrame, Vector3.zero
	else
		return getAdorneeBasePartCFrame(adornee), getAdorneeAlignedSize(adornee)
	end
end

return getAdorneeBoundingBox
