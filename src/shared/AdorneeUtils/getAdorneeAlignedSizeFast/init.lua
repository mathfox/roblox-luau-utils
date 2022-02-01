local getAdorneeBasePart = require(script.Parent.getAdorneeBasePart)

local function getAdorneeAlignedSizeFast(adornee: Instance): Vector3?
	if adornee:IsA("Model") then
		return select(2, adornee:GetBoundingBox())
	elseif adornee:IsA("Humanoid") then
		return if adornee.Parent then select(2, adornee.Parent:GetBoundingBox()) else nil
	else
		local adorneeBasePart: BasePart? = getAdorneeBasePart(adornee)

		return if adorneeBasePart then adorneeBasePart.Size else nil
	end
end

return getAdorneeAlignedSizeFast
