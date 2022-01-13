local getAdorneeBasePart = require(script.Parent.getAdorneeBasePart)

local function getAdorneeAlignedSize(adornee: Instance): Vector3?
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeAlignedSize' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'getAdorneeAlignedSize' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	end

	if adornee:IsA("Model") then
		return select(2, adornee:GetBoundingBox())
	elseif adornee:IsA("Humanoid") then
		return if adornee.Parent then select(2, adornee.Parent:GetBoundingBox()) else nil
	else
		local adorneeBasePart: BasePart? = getAdorneeBasePart(adornee)

		return if adorneeBasePart then adorneeBasePart.Size else nil
	end
end

return getAdorneeAlignedSize
