local function teleportHumanoidToCFrameFast(humanoid: Humanoid, cframe: CFrame)
	local rootPart = humanoid.RootPart
	if not rootPart then
		return
	end

	rootPart.CFrame = cframe + Vector3.new(0, rootPart.Size.Y / 2 + humanoid.HipHeight, 0)
end

return teleportHumanoidToCFrameFast
