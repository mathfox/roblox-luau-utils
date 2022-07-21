local function getAdorneeBasePart(adornee: Instance): BasePart?
	if adornee:IsA("BasePart") then
		return adornee
	elseif adornee:IsA("Model") then
		return adornee.PrimaryPart or adornee:FindFirstChildWhichIsA("BasePart")
	elseif adornee:IsA("Attachment") then
		local part: Instance? = adornee.Parent
		return if part and part:IsA("BasePart") then part :: BasePart else nil
	elseif adornee:IsA("Humanoid") then
		return adornee.RootPart
	elseif adornee:IsA("Accessory") or adornee:IsA("Clothing") then
		return adornee:FindFirstChildWhichIsA("BasePart")
	elseif adornee:IsA("Tool") then
		local handle: Instance? = adornee:FindFirstChild("Handle")
		return if handle and handle:IsA("BasePart") then handle :: BasePart else nil
	else
		return nil
	end
end

return getAdorneeBasePart
