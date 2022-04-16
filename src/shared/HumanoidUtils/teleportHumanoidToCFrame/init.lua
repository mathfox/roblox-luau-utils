local function teleportHumanoidToCFrame(humanoid: Humanoid, cframe: CFrame)
	local rootPart = humanoid.RootPart
	if rootPart then
		rootPart.CFrame = cframe + Vector3.new(0, rootPart.Size.Y / 2 + humanoid.HipHeight, 0)
	end
end

return teleportHumanoidToCFrame
