local function getAliveRootPartFromDescendant(descendant: Instance)
	local model = descendant:FindFirstAncestorOfClass("Model")
	if not model then
		return nil
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	return if humanoid and humanoid.Health > 0 then humanoid.RootPart else nil
end

return getAliveRootPartFromDescendant
