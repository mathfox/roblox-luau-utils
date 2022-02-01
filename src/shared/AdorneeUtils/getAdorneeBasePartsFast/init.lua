local Types = require(script.Parent.Types)

local function getAdorneeBasePartsFast(adornee: Instance): Types.BaseParts
	local parts: Types.BaseParts = { if adornee:IsA("BasePart") then adornee else nil }

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

return getAdorneeBasePartsFast
