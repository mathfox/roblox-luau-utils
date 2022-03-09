local function isPartOfAdornee(adornee: Instance, part: BasePart)
	return if adornee:IsA("Humanoid")
		then if adornee.Parent then part:IsDescendantOf(adornee.Parent) else false
		else adornee == part or part:IsDescendantOf(adornee)
end

return isPartOfAdornee
