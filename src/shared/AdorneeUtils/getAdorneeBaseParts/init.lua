local function getAdorneeBaseParts(adornee: Instance)
	local parts: { BasePart } = { if adornee:IsA("BasePart") then adornee else nil }

	local searchParent: Instance? = if adornee:IsA("Humanoid") then adornee.Parent else adornee

	if searchParent then
		for _, part in searchParent:GetDescendants() do
			if part:IsA("BasePart") then
				table.insert(parts, part)
			end
		end
	end

	return parts
end

return getAdorneeBaseParts
