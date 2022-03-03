local function getAdorneeBasePartFast(adornee: Instance)
	if adornee:IsA("BasePart") then
		return adornee :: BasePart
	elseif adornee:IsA("Model") then
		local primaryPart: BasePart? = adornee.PrimaryPart
		if primaryPart then
			return primaryPart :: BasePart
		else
			local part = adornee:FindFirstChildWhichIsA("BasePart")
			return if part then part :: BasePart else nil
		end
	elseif adornee:IsA("Attachment") then
		local part: Instance? = adornee.Parent
		return if part and part:IsA("BasePart") then part :: BasePart else nil
	elseif adornee:IsA("Humanoid") then
		local rootPart: BasePart? = adornee.RootPart
		return if rootPart then rootPart :: BasePart else nil
	elseif adornee:IsA("Accessory") or adornee:IsA("Clothing") then
		local part: BasePart? = adornee:FindFirstChildWhichIsA("BasePart")
		return if part then part :: BasePart else nil
	elseif adornee:IsA("Tool") then
		local handle: Instance? = adornee:FindFirstChild("Handle")
		return if handle and handle:IsA("BasePart") then handle :: BasePart else nil
	else
		return nil
	end
end

return getAdorneeBasePartFast
