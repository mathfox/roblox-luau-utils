local function getAliveRootPartFromModel(model: Model)
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	return if humanoid and humanoid.Health > 0 then humanoid else nil
end

return getAliveRootPartFromModel
