local function getAdorneeBasePartFast(adornee: Instance): BasePart?
	if adornee:IsA("BasePart") then
		return adornee
	elseif adornee:IsA("Model") then
		local primaryPart: BasePart? = adornee.PrimaryPart

		return if primaryPart then primaryPart else adornee:FindFirstChildWhichIsA("BasePart")
	elseif adornee:IsA("Attachment") then
		return adornee.Parent
	elseif adornee:IsA("Humanoid") then
		return adornee.RootPart
	elseif adornee:IsA("Accessory") or adornee:IsA("Clothing") then
		return adornee:FindFirstChildWhichIsA("BasePart")
	elseif adornee:IsA("Tool") then
		local handle: BasePart? = adornee:FindFirstChild("Handle")

		return if handle and handle:IsA("BasePart") then handle else nil
	else
		return nil
	end
end

return getAdorneeBasePartFast
