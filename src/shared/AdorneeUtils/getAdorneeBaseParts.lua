export type BaseParts = { BasePart }

local function getAdorneeBaseParts(adornee: Instance): BaseParts
	if adornee == nil then
		error("missing argument #1 to 'getAdorneeBaseParts' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'getAdorneeBaseParts' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	end

	local parts: BaseParts = { if adornee:IsA("BasePart") then adornee else nil }

	local searchParent: Instance? = if adornee:IsA("Humanoid") then adornee.Parent else adornee

	if searchParent then
		for _, part in ipairs(searchParent:GetDescendants()) do
			if part:IsA("BasePart") then
				table.insert(parts, part)
			end
		end
	end

	return parts
end

return getAdorneeBaseParts
