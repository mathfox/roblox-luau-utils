local function getRenderAdornee(adornee: Instance)
	if adornee:IsA("BasePart") then
		return adornee :: BasePart
	elseif adornee:IsA("Model") then
		return adornee :: Model
	elseif adornee:IsA("Attachment") then
		return adornee :: Attachment
	elseif adornee:IsA("Humanoid") then
		return adornee.Parent :: Model
	elseif adornee:IsA("Accessory") or adornee:IsA("Clothing") then
		return adornee:FindFirstChildWhichIsA("BasePart")
	elseif adornee:IsA("Tool") then
		local handle: BasePart? = adornee:FindFirstChild("Handle")

		return if handle and handle:IsA("BasePart") then handle :: BasePart else nil
	else
		return nil
	end
end

return getRenderAdornee
