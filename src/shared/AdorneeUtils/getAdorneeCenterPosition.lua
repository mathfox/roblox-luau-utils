local function getAdorneeCenterPosition(adornee: Instance): Vector3?
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeCenterPosition' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(
			("invalid argument #1 to 'getAdorneeCenterPosition' (Instance expected, got %s)"):format(typeof(adornee)),
			2
		)
	end

	if adornee:IsA("BasePart") then
		return adornee.Position
	elseif adornee:IsA("Model") then
		return adornee:GetBoundingBox().p
	elseif adornee:IsA("Attachment") then
		return adornee.WorldPosition
	elseif adornee:IsA("Humanoid") then
		local rootPart: BasePart? = adornee.RootPart

		return if rootPart then rootPart.Position else nil
	elseif adornee:IsA("Accessory") or adornee:IsA("Clothing") then
		local handle: BasePart? = adornee:FindFirstChildWhichIsA("BasePart")

		return if handle then handle.Position else nil
	elseif adornee:IsA("Tool") then
		local handle: BasePart? = adornee:FindFirstChild("Handle")

		return if handle and handle:IsA("BasePart") then handle.Position else nil
	else
		return nil
	end
end

return getAdorneeCenterPosition
