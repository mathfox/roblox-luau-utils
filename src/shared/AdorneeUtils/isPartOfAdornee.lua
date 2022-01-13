local function isPartOfAdornee(adornee: Instance, part: BasePart): boolean
	if adornee == nil then
		error("missing argument #1 to 'isPartOfAdornee' (Instance expected)", 2)
	elseif typeof(adornee) ~= "Instance" then
		error(("invalid argument #1 to 'isPartOfAdornee' (Instance expected, got %s)"):format(typeof(adornee)), 2)
	elseif part == nil then
		error("missing argument #2 to 'isPartOfAdornee' (BasePart expected)", 2)
	elseif typeof(part) ~= "Instance" or not part:IsA("BasePart") then
		error(("invalid argument #2 to 'isPartOfAdornee' (BasePart expected, got %s)"):format(typeof(part)), 2)
	end

	if adornee:IsA("Humanoid") then
		local model: Model? = adornee.Parent

		return if model then part:IsDescendantOf(model) else false
	end

	return adornee == part or part:IsDescendantOf(adornee)
end

return isPartOfAdornee
