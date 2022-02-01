local function isPartOfAdorneeFast(adornee: Instance, part: BasePart): boolean
	if adornee:IsA("Humanoid") then
		local model: Model? = adornee.Parent

		return if model then part:IsDescendantOf(model) else false
	end

	return adornee == part or part:IsDescendantOf(adornee)
end

return isPartOfAdorneeFast
