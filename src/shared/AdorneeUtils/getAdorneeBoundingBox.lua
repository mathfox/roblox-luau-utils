local getAdorneeBasePartCFrame = require(script.Parent.getAdorneeBasePartCFrame)
local getAdorneeAlignedSize = require(script.Parent.getAdorneeAlignedSize)

local function getAdorneeBoundingBox(adornee: Instance): (CFrame, Vector3)
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeBoundingBox' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'getAdorneeBoundingBox' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	end

	if adornee:IsA("Model") then
		return adornee:GetBoundingBox()
	elseif adornee:IsA("Attachment") then
		return adornee.WorldCFrame, Vector3.zero
	end

	return getAdorneeBasePartCFrame(adornee), getAdorneeAlignedSize(adornee)
end

return getAdorneeBoundingBox
