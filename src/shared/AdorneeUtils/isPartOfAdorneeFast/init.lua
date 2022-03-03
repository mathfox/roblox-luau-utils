local function isPartOfAdorneeFast(adornee: Instance, part: BasePart)
	if adornee:IsA("Humanoid") then
		local model: Model? = adornee.Parent
		return if model then part:IsDescendantOf(model) else false
	else
		return adornee == part or part:IsDescendantOf(adornee)
	end
end

return isPartOfAdorneeFast
