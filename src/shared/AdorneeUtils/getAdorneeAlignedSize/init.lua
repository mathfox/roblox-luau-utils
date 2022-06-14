local getAdorneeBasePart = require(script.Parent.getAdorneeBasePart)

local function getAdorneeAlignedSize(adornee: Instance)
	if adornee:IsA("Model") then
		return select(2, adornee:GetBoundingBox())
	elseif adornee:IsA("Humanoid") then
		return if adornee.Parent then select(2, (adornee.Parent :: Model):GetBoundingBox()) else nil
	else
		local adorneeBasePart = getAdorneeBasePart(adornee)
		return if adorneeBasePart then adorneeBasePart.Size else nil
	end
end

return getAdorneeAlignedSize
